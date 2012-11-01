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

# redis = Ouroboros.redis["andromeda_#{ Rails.env }"]
# redis.keys('andromeda_*').each do |key|
#   redis.del key
# end

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

# Beta Subjects
files = %w(B15-F09_1 B15-F09_10 B15-F09_10_F475W B15-F09_10_F475W_sc B15-F09_10_sc B15-F09_11 B15-F09_11_F475W B15-F09_11_F475W_sc B15-F09_11_sc B15-F09_12 B15-F09_12_F475W B15-F09_12_F475W_sc B15-F09_12_sc B15-F09_13 B15-F09_13_F475W B15-F09_13_F475W_sc B15-F09_13_sc B15-F09_14 B15-F09_14_F475W B15-F09_14_F475W_sc B15-F09_14_sc B15-F09_15 B15-F09_15_F475W B15-F09_15_F475W_sc B15-F09_15_sc B15-F09_16 B15-F09_16_F475W B15-F09_16_F475W_sc B15-F09_16_sc B15-F09_17 B15-F09_17_F475W B15-F09_17_F475W_sc B15-F09_17_sc B15-F09_18 B15-F09_18_F475W B15-F09_18_F475W_sc B15-F09_18_sc B15-F09_19 B15-F09_19_F475W B15-F09_19_F475W_sc B15-F09_19_sc B15-F09_1_F475W B15-F09_1_F475W_sc B15-F09_1_sc B15-F09_2 B15-F09_20 B15-F09_20_F475W B15-F09_20_F475W_sc B15-F09_20_sc B15-F09_21 B15-F09_21_F475W B15-F09_21_F475W_sc B15-F09_21_sc B15-F09_22 B15-F09_22_F475W B15-F09_22_F475W_sc B15-F09_22_sc B15-F09_23 B15-F09_23_F475W B15-F09_23_F475W_sc B15-F09_23_sc B15-F09_24 B15-F09_24_F475W B15-F09_24_F475W_sc B15-F09_24_sc B15-F09_25 B15-F09_25_F475W B15-F09_25_F475W_sc B15-F09_25_sc B15-F09_26 B15-F09_26_F475W B15-F09_26_F475W_sc B15-F09_26_sc B15-F09_27 B15-F09_27_F475W B15-F09_27_F475W_sc B15-F09_27_sc B15-F09_28 B15-F09_28_F475W B15-F09_28_F475W_sc B15-F09_28_sc B15-F09_2_F475W B15-F09_2_F475W_sc B15-F09_2_sc B15-F09_3 B15-F09_3_F475W B15-F09_3_F475W_sc B15-F09_3_sc B15-F09_4 B15-F09_4_F475W B15-F09_4_F475W_sc B15-F09_4_sc B15-F09_5 B15-F09_5_F475W B15-F09_5_F475W_sc B15-F09_5_sc B15-F09_6 B15-F09_6_F475W B15-F09_6_F475W_sc B15-F09_6_sc B15-F09_7 B15-F09_7_F475W B15-F09_7_F475W_sc B15-F09_7_sc B15-F09_8 B15-F09_8_F475W B15-F09_8_F475W_sc B15-F09_8_sc B15-F09_9 B15-F09_9_F475W B15-F09_9_F475W_sc B15-F09_9_sc B15-F11_1 B15-F11_10 B15-F11_10_F475W B15-F11_10_F475W_sc B15-F11_10_sc B15-F11_11 B15-F11_11_F475W B15-F11_11_F475W_sc B15-F11_11_sc B15-F11_12 B15-F11_12_F475W B15-F11_12_F475W_sc B15-F11_12_sc B15-F11_13 B15-F11_13_F475W B15-F11_13_F475W_sc B15-F11_13_sc B15-F11_14 B15-F11_14_F475W B15-F11_14_F475W_sc B15-F11_14_sc B15-F11_15 B15-F11_15_F475W B15-F11_15_F475W_sc B15-F11_15_sc B15-F11_16 B15-F11_16_F475W B15-F11_16_F475W_sc B15-F11_16_sc B15-F11_17 B15-F11_17_F475W B15-F11_17_F475W_sc B15-F11_17_sc B15-F11_18 B15-F11_18_F475W B15-F11_18_F475W_sc B15-F11_18_sc B15-F11_19 B15-F11_19_F475W B15-F11_19_F475W_sc B15-F11_19_sc B15-F11_1_F475W B15-F11_1_F475W_sc B15-F11_1_sc B15-F11_2 B15-F11_20 B15-F11_20_F475W B15-F11_20_F475W_sc B15-F11_20_sc B15-F11_21 B15-F11_21_F475W B15-F11_21_F475W_sc B15-F11_21_sc B15-F11_22 B15-F11_22_F475W B15-F11_22_F475W_sc B15-F11_22_sc B15-F11_23 B15-F11_23_F475W B15-F11_23_F475W_sc B15-F11_23_sc B15-F11_24 B15-F11_24_F475W B15-F11_24_F475W_sc B15-F11_24_sc B15-F11_25 B15-F11_25_F475W B15-F11_25_F475W_sc B15-F11_25_sc B15-F11_26 B15-F11_26_F475W B15-F11_26_F475W_sc B15-F11_26_sc B15-F11_27 B15-F11_27_F475W B15-F11_27_F475W_sc B15-F11_27_sc B15-F11_28 B15-F11_28_F475W B15-F11_28_F475W_sc B15-F11_28_sc B15-F11_2_F475W B15-F11_2_F475W_sc B15-F11_2_sc B15-F11_3 B15-F11_3_F475W B15-F11_3_F475W_sc B15-F11_3_sc B15-F11_4 B15-F11_4_F475W B15-F11_4_F475W_sc B15-F11_4_sc B15-F11_5 B15-F11_5_F475W B15-F11_5_F475W_sc B15-F11_5_sc B15-F11_6 B15-F11_6_F475W B15-F11_6_F475W_sc B15-F11_6_sc B15-F11_7 B15-F11_7_F475W B15-F11_7_F475W_sc B15-F11_7_sc B15-F11_8 B15-F11_8_F475W B15-F11_8_F475W_sc B15-F11_8_sc B15-F11_9 B15-F11_9_F475W B15-F11_9_F475W_sc B15-F11_9_sc B21-F14_1 B21-F14_10 B21-F14_10_F475W B21-F14_10_F475W_sc B21-F14_10_sc B21-F14_11 B21-F14_11_F475W B21-F14_11_F475W_sc B21-F14_11_sc B21-F14_12 B21-F14_12_F475W B21-F14_12_F475W_sc B21-F14_12_sc B21-F14_13 B21-F14_13_F475W B21-F14_13_F475W_sc B21-F14_13_sc B21-F14_14 B21-F14_14_F475W B21-F14_14_F475W_sc B21-F14_14_sc B21-F14_15 B21-F14_15_F475W B21-F14_15_F475W_sc B21-F14_15_sc B21-F14_16 B21-F14_16_F475W B21-F14_16_F475W_sc B21-F14_16_sc B21-F14_17 B21-F14_17_F475W B21-F14_17_F475W_sc B21-F14_17_sc B21-F14_18 B21-F14_18_F475W B21-F14_18_F475W_sc B21-F14_18_sc B21-F14_19 B21-F14_19_F475W B21-F14_19_F475W_sc B21-F14_19_sc B21-F14_1_F475W B21-F14_1_F475W_sc B21-F14_1_sc B21-F14_2 B21-F14_20 B21-F14_20_F475W B21-F14_20_F475W_sc B21-F14_20_sc B21-F14_21 B21-F14_21_F475W B21-F14_21_F475W_sc B21-F14_21_sc B21-F14_22 B21-F14_22_F475W B21-F14_22_F475W_sc B21-F14_22_sc B21-F14_23 B21-F14_23_F475W B21-F14_23_F475W_sc B21-F14_23_sc B21-F14_24 B21-F14_24_F475W B21-F14_24_F475W_sc B21-F14_24_sc B21-F14_25 B21-F14_25_F475W B21-F14_25_F475W_sc B21-F14_25_sc B21-F14_26 B21-F14_26_F475W B21-F14_26_F475W_sc B21-F14_26_sc B21-F14_27 B21-F14_27_F475W B21-F14_27_F475W_sc B21-F14_27_sc B21-F14_28 B21-F14_28_F475W B21-F14_28_F475W_sc B21-F14_28_sc B21-F14_2_F475W B21-F14_2_F475W_sc B21-F14_2_sc B21-F14_3 B21-F14_3_F475W B21-F14_3_F475W_sc B21-F14_3_sc B21-F14_4 B21-F14_4_F475W B21-F14_4_F475W_sc B21-F14_4_sc B21-F14_5 B21-F14_5_F475W B21-F14_5_F475W_sc B21-F14_5_sc B21-F14_6 B21-F14_6_F475W B21-F14_6_F475W_sc B21-F14_6_sc B21-F14_7 B21-F14_7_F475W B21-F14_7_F475W_sc B21-F14_7_sc B21-F14_8 B21-F14_8_F475W B21-F14_8_F475W_sc B21-F14_8_sc B21-F14_9 B21-F14_9_F475W B21-F14_9_F475W_sc B21-F14_9_sc)

dirname = File.dirname(__FILE__)
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

files.each.with_index do |name, index|
  
  brickname = name.gsub('_F475W', '').gsub('_sc', '')
  center = centers[brickname]
  coords = [center["ra"], center["dec"]]
  center = [center["x"], center["y"]]
  year1clusters = year1[brickname]
  synthetic_clusters = synthetic[brickname]
  
  AndromedaSubject.create({
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
  
  puts "#{ index + 1 } / #{ files.length }"
end


# AndromedaSubject.activate_randomly