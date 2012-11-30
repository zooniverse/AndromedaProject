# Create a CSV for Sellers to ingest in the form of:
# name, location, thumbnail_location, ra, dec

require 'csv'
require 'json'

dirname = File.dirname(__FILE__)

# Create an output file
output = CSV::open('andromeda_manifest.csv', 'wb')

header = ['zooniverse_id', 'name', 'location', 'thumbnail_location', 'ra', 'dec']
output << header

# Get the center of each subject
centers = JSON.parse(File.read("#{dirname}/../data/image-centers.json"))

# Parse ids for all subjects
CSV.foreach("#{dirname}/../data/subjects_with_ids.csv", 'r') do |row|
  zooniverse_id = row[1]
  subimg = row[2].sub('_sc', '')
  center = centers[subimg]
  if center
    ra = center['ra']
    dec = center['dec']
  end
  
  location = "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/color/#{subimg}.jpg"
  thumbnail_location = "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/color/#{subimg}.jpg"
  puts zooniverse_id, subimg, ra, dec
  output << [zooniverse_id, subimg, location, thumbnail_location, ra, dec]
end

# subjects = []
# 
# dirname = File.dirname(__FILE__)
# File.open("#{dirname}/../data/andromeda_subjects.txt", 'r') do |f|
#   while (line = f.gets)
#     subjects << line
#   end
# end
# 
# centers = JSON.parse(File.read("#{dirname}/../data/image-centers.json"))
# 
# zooniverse_ids = JSON.parse(File.read("#{dirname}/../data/andromeda_subjects.json"))
# id_hash = {}
# zooniverse_ids.each do |item|
#   subimage = item['location'].sub('http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/color/', '').split('.')[0]
#   id_hash[subimage] = item['zooniverse_id']
# end
# 
# CSV::open('andromeda_subjects.csv', 'wb') do |csv|
#   header = ['zooniverse_id', 'name', 'location', 'thumbnail_location', 'ra', 'dec']
#   csv << header
#   
#   subjects.each do |name|
#     name = name.gsub(/\s+/, "")
#     zooniverse_id = id_hash[name]
#     
#     next if zooniverse_id == nil
#     
#     center_name = name.sub('_F475W', '').sub('_sc', '')
#     center = centers[center_name]
#     
#     row = []
#     row << id_hash[name]
#     row << name
#     row << "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/color/#{name}.jpg"
#     row << "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/color/#{name}.jpg"
#     row << center['ra']
#     row << center['dec']
#         
#     # if centers.has_key?(center_name)
#     #   center = centers[center_name]
#     #   row << center['ra']
#     #   row << center['dec']
#     # else
#     #   puts center_name
#     # end
#     
#     csv << row
#   end
#   
# end