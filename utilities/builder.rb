require 'json'
require 'csv'

project = AndromedaSubject.project

Classification.where(project_id: project.id).destroy_all if project
Recent.where(project_id: project.id).destroy_all if project
Favorite.where(project_id: project.id).destroy_all if project

if project
  user_total = User.count
  user_index = 0
  User.collection.find({ }, { timeout: false, fields: ['projects'] }) do |user_cursor|
    while user_cursor.has_next?
      user = user_cursor.next_document
        
      if user['projects'] && user['projects'][project.id.to_s]
        User.collection.update({ _id: user['_id'] }, {
          :$set => { "projects.#{ project.id.to_s }" => { } }
        })
      end
      
      puts "#{ user_index += 1 } / #{ user_total }"
    end
  end
end

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

dirname = File.dirname(__FILE__)

# All Subjects
subjects = {}
CSV.foreach("#{dirname}/../data/subjects_with_ids.csv") do |row|
  _id, zooniverse_id, subimg = row
  subjects[subimg] = {'_id' => _id, 'zooniverse_id' => zooniverse_id}
end

# Parse for image centers
centers = JSON.parse(File.read("#{dirname}/../data/image-centers.json"))

# Parse Synthetic Cluster Catalog
synthetic = {}
CSV.foreach("#{dirname}/../data/synthetic-clusters.csv") do |row|
  subimg, fcid, x, y, ra, dec, reff, pixradius = row
  unless synthetic.has_key?(subimg)
    synthetic[subimg] = []
  end
  object = {
    fcid: fcid.strip(),
    x: x.strip(),
    y: y.strip(),
    pixradius: pixradius.strip(),
    ra: ra.strip(),
    dec: dec.strip(),
    reff: reff.strip()
  }
  synthetic[subimg].push(object)
end

#
# Create All Subjects
#
index = 0
subjects.each_pair do |name, ids|
  
  brickname = name.gsub('_F475W', '').gsub('_sc', '')
  puts brickname
  
  _id = BSON::ObjectId(ids['_id'])
  zooniverse_id = ids['zooniverse_id']
  
  if name == 'tutorial'
    AndromedaSubject.create({
      _id: _id,
      zooniverse_id: zooniverse_id,
      project_id: project.id,
      tutorial: 'true',
      workflow_ids: [ workflow.id ],
      coords: [11.318979, 41.958249],
      location: {
        standard: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/color/#{ name }.jpg",
        thumbnail: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/color/#{ name }.jpg"
      },
      metadata: {
        subimg: 'B17-F16_tutorial',
        center: ["0.4701", "0.3234"]
      }
    })
  else
    center = centers[brickname]
    coords = [center["ra"], center["dec"]]
    center = [center["nx"], center["ny"]]
    
    metadata = {}
    metadata['subimg'] = name
    metadata['center'] = center
    if name.include? '_sc'
      metadata['synthetic'] = synthetic[brickname]
    end
    
    AndromedaSubject.create({
      _id: _id,
      zooniverse_id: zooniverse_id,
      project_id: project.id,
      workflow_ids: [ workflow.id ],
      coords: coords,
      location: {
        standard: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/color/#{ name }.jpg",
        thumbnail: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/color/#{ name }.jpg"
      },
      metadata: metadata
    })
  end
  
  puts "#{ index + 1 } / #{ subjects.length }"
  index += 1
end

AndromedaSubject.activate_randomly if Rails.env == "development"