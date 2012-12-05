# Create a CSV for Sellers to ingest in the form of:
# name, location, thumbnail_location, ra, dec

require 'csv'
require 'json'

dirname = File.dirname(__FILE__)

# Create an output file
output = CSV::open('andromeda_manifest_fix.csv', 'wb')

header = ['zooniverse_id', 'old_location', 'old_thumbnail_location', 'new_location', 'new_thumbnail_location']
output << header

# Get the center of each subject
centers = JSON.parse(File.read("#{dirname}/../data/image-centers.json"))

# Parse ids for all subjects
CSV.foreach("#{dirname}/../data/subjects_with_ids.csv", 'r') do |row|
  
  if row[2].include?('_sc')
    zooniverse_id = row[1]
    name = row[2]
    subimg = row[2].sub('_sc', '')
    center = centers[subimg]
    if center
      ra = center['ra']
      dec = center['dec']
    end
    
    old_location = "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/color/#{subimg}.jpg"
    old_thumbnail_location = "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/color/#{subimg}.jpg"
    
    new_location = "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/color/#{name}.jpg"
    new_thumbnail_location = "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/color/#{name}.jpg"
    
    puts zooniverse_id, old_location, old_thumbnail_location, new_location, new_thumbnail_location
    output << [zooniverse_id, old_location, old_thumbnail_location, new_location, new_thumbnail_location]
  end
end
