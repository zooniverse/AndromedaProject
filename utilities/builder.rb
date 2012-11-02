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

if Rails.env == 'development'
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
CSV.foreach("#{dirname}/../data/andromeda_subjects_with_ids.csv") do |row|
  _id, zooniverse_id, subimg = row
  subjects[subimg] = {'_id' => _id, 'zooniverse_id' => zooniverse_id}
end

centers = JSON.parse(File.read("#{dirname}/../data/image-centers.json"))
year1 = {}
synthetic = {}

# Parse Year1 PHAT Stellar Cluster Catalog
CSV.foreach("#{dirname}/../data/year1catalog.csv") do |row|
  fieldname, cluster, x, y, pixradius, ra, dec = row
  unless year1.has_key?(fieldname)
    year1[fieldname] = []
  end
  object = {
    cluster: cluster.strip(),
    x: x.strip(),
    y: y.strip(),
    pixradius: pixradius.strip(),
    ra: ra.strip(),
    dec: dec.strip()
  }
  year1[fieldname].push(object)
end

# Parse Synthetic Cluster Catalog
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

index = 0
subjects.each_pair do |name, ids|
  brickname = name.gsub('_F475W', '').gsub('_sc', '')
  
  _id = ids['_id']
  zooniverse_id = ids['zooniverse_id']
  
  center = centers[brickname]
  coords = [center["ra"], center["dec"]]
  center = [center["x"], center["y"]]
  year1clusters = year1[brickname]
  synthetic_clusters = synthetic[brickname]
  
  AndromedaSubject.create({
    _id: _id,
    zooniverse_id: zooniverse_id,
    project_id: project.id,
    workflow_ids: [ workflow.id ],
    coords: coords,
    location: {
      standard: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/#{ name }.jpg",
      thumbnail: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/#{ name }.jpg"
    },
    metadata: {
      subimg: name,
      center: center,
      year1: year1clusters,
      synthetic: synthetic_clusters
    }
  })
  
  puts "#{ index + 1 } / #{ subjects.length }"
  index += 1
end

AndromedaSubject.activate_randomly if Rails.env == 'development'