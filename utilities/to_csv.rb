gem 'mongo'
gem 'bson_ext'
require 'mongo'


# connect to mongod
c = Classification.where(:project_id => BSON::ObjectId('509879e66aa0e05d9c000001'))
total = c.count

csv = File.open 'classifications.csv', 'w'
csv.puts 'subject_id,classification_id,annotation_type,annotation'

index = 0

ap = c.all
ap.each do |classification|
  id = classification.id.to_s
  subject_id = classification.subject_ids
  
  classification.annotations.each do |annotation|
    if annotation['species']
      species = annotation['species']
      points = annotation['points'].values.collect{ |point| "[#{ point['x'] }:#{point['y'] }]" }.join(';')
      csv.puts [subject_id, id, species, points].join(',')
    end
  end
end

csv.close
