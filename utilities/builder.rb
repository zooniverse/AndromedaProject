require 'json'
require 'csv'

project = AndromedaSubject.project

Classification.where(project_id: project.id).destroy_all if project
Recent.where(project_id: project.id).destroy_all if project
Favorite.where(project_id: project.id).destroy_all if project

User.all.each do |user|
  if user.attributes['projects']
    if project && user.attributes['projects'][project.id.to_s]
      user.update :$set => { "projects.#{ project.id.to_s }" => { } }
    end
  end
end

AndromedaSubject.destroy_all
project.workflows.destroy_all if project
project.destroy if project

redis = Ouroboros.redis["andromeda_#{ Rails.env }"]
redis.keys.each do |key|
  redis.del key
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

files = %w(B09-F11_1 B09-F11_10 B09-F11_11 B09-F11_12 B09-F11_13 B09-F11_14 B09-F11_15 B09-F11_16 B09-F11_17 B09-F11_18 B09-F11_19 B09-F11_2 B09-F11_20 B09-F11_21 B09-F11_22 B09-F11_23 B09-F11_24 B09-F11_25 B09-F11_26 B09-F11_27 B09-F11_28 B09-F11_3 B09-F11_4 B09-F11_5 B09-F11_6 B09-F11_7 B09-F11_8 B09-F11_9 B15-F03_1 B15-F03_10 B15-F03_11 B15-F03_12 B15-F03_13 B15-F03_14 B15-F03_15 B15-F03_16 B15-F03_17 B15-F03_18 B15-F03_19 B15-F03_2 B15-F03_20 B15-F03_21 B15-F03_22 B15-F03_23 B15-F03_24 B15-F03_25 B15-F03_26 B15-F03_27 B15-F03_28 B15-F03_3 B15-F03_4 B15-F03_5 B15-F03_6 B15-F03_7 B15-F03_8 B15-F03_9 B23-F05_1 B23-F05_10 B23-F05_11 B23-F05_12 B23-F05_13 B23-F05_14 B23-F05_15 B23-F05_16 B23-F05_17 B23-F05_18 B23-F05_19 B23-F05_2 B23-F05_20 B23-F05_21 B23-F05_22 B23-F05_23 B23-F05_24 B23-F05_25 B23-F05_26 B23-F05_27 B23-F05_28 B23-F05_3 B23-F05_4 B23-F05_5 B23-F05_6 B23-F05_7 B23-F05_8 B23-F05_9)

dirname = File.dirname(__FILE__)
centers = JSON.parse(File.read("#{dirname}/../data/image-centers.json"))

year1 = {}
CSV.foreach("#{dirname}/brick-number-year1.csv") do |row|
  brick, id, x, y = row
  id = id.strip()
  x = x.strip()
  y = y.strip()
  unless year1.has_key?(brick)
    year1[brick] = []
  end
  cluster = {
    id: id,
    x: x,
    y: y
  }
  year1[brick].push(cluster)
end

files.each.with_index do |name, index|
  
  wcs = JSON.parse(File.read("#{dirname}/../data/headers/#{name}.fits.json"))
  center = centers[name]
  
  clusters = year1[name]
  
  AndromedaSubject.create({
    project_id: project.id,
    workflow_ids: [ workflow.id ],
    coords: [ ],
    location: {
      standard: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/#{ name }.jpg"
    },
    metadata: {
      filename: name,
      wcs: wcs,
      subimageCenter: center,
      year1: clusters
    }
  })
  
  puts "#{ index + 1 } / #{ files.length }"
end


AndromedaSubject.activate_randomly
