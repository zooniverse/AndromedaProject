
require 'bson'
require 'json'


# Base ID for Andromeda Project subjects
@base_id = '50b781761a320e4aac'

# Offset index to the nth + 1 subject (i.e. 12425 subjects in round 1)
@index = 12426

def next_id
  BSON::ObjectId("#{ @base_id }#{ @index.to_s(16).rjust(6, '0') }").tap{ @index += 1 }
end

class ZooniverseIdGenerator
  def self.next_id
    @last_id ||= 'AAP00009l5'
    @last_id = increment_zoo_id
  end
  
  def self.increment_zoo_id
    id = @last_id.dup
    id.reverse.each_char.with_index do |b, pos|
      if b == '9'
        id[-pos - 1] = 'a'
        return id
      elsif b == ?z
        id[-pos - 1] = '0'
      else
        id[-pos - 1] = b.next.chr
        return id
      end
    end
  end
end

@data_path = File::join(File.dirname(__FILE__), '..', 'data')

project = AndromedaSubject.project

AndromedaSubject.destroy_all
project.workflows.destroy_all if project
project.destroy if project

if Rails.env == "development"
  redis = Ouroboros.redis["andromeda_#{ Rails.env }"]
  redis.keys('andromeda_*').each do |key|
    redis.del key
  end
end

project = Project.where(name: 'andromeda').first || Project.create({
  name: 'andromeda'
})

workflow = Workflow.where(name: 'andromeda').first || Workflow.create({
  _id: BSON::ObjectId('5052085f516bcb6b8a000003'),
  project_id: project.id,
  primary: false,
  name: 'Andromeda',
  description: 'Andromeda',
  entities: []
})

# Using glob to exclude F475W and F555W images
phat_subjects = Dir["#{ @data_path }/jpg_final_2/*[0-9].jpg"]
phat_synthetics = Dir["#{ @data_path }/jpg_fcz2/*[0-9].jpg"]
archival_subjects = Dir["#{ @data_path }/jpg_strip/*[0-9].jpg"]
archival_synthetics = Dir["#{ @data_path }/jpg_r2pt2/*[0-9].jpg"]

phat_subjects.map! { |subject| File.basename(subject, '.jpg') }
phat_synthetics.map! { |subject| File.basename(subject, '.jpg') }
archival_subjects.map! { |subject| File.basename(subject, '.jpg') }
archival_synthetics.map! { |subject| File.basename(subject, '.jpg') }

subjects = []
subjects.concat(phat_subjects).concat(phat_synthetics).concat(archival_subjects).concat(archival_synthetics)
subjects.sort!

# Parse for image centers
centers = JSON.parse( File.read("#{File.dirname(__FILE__)}/../data/image-centers-round-2.json") )
synthetics = JSON.parse( File.read("#{File.dirname(__FILE__)}/../data/synthetic-clusters-round-2.json") )

subjects.each do |subject|
  puts "#{subject}\t#{centers[subject]}"
  puts "#{subject}\t#{synthetics[subject]}"
  
  center = centers[subject]
  synthetic = synthetics[subject]
  
  coords = [ center["ra"], center["dec"] ]
  nxny = [ center["nx"], center["ny"] ]
  
  metadata = {
    subimg: subject,
    center: nxny
  }
  metadata['synthetic'] = synthetic if synthetic
  
  puts AndromedaSubject.create({
    _id: next_id,
    zooniverse_id: ZooniverseIdGenerator.next_id,
    project_id: project.id,
    workflow_ids: [ workflow.id ],
    coords: coords,
    location: {
      standard: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/#{ subject }.jpg",
      inverted: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/inverted/#{ subject }.jpg",
      thumbnail: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/#{ subject }.jpg"
    },
    metadata: metadata
  })
  
  
end

# AndromedaSubject.activate_randomly
SubjectImporter.perform_async 'AndromedaSubject'