# Create a CSV for Sellers to ingest in the form of:
# name, location, thumbnail_location, ra, dec

require 'csv'
require 'json'

subjects = []

dirname = File.dirname(__FILE__)
File.open("#{dirname}/../data/andromeda_subjects.txt", 'r') do |f|
  while (line = f.gets)
    subjects << line
  end
end

centers = JSON.parse(File.read("#{dirname}/../data/image-centers.json"))

zooniverse_ids = JSON.parse(File.read("#{dirname}/../data/andromeda_subjects.json"))
id_hash = {}
zooniverse_ids.each do |item|
  subimage = item['location'].sub('http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/', '').split('.')[0]
  id_hash[subimage] = item['zooniverse_id']
end

CSV::open('andromeda_subjects.csv', 'wb') do |csv|
  header = ['zooniverse_id', 'name', 'location', 'thumbnail_location', 'ra', 'dec']
  csv << header
  
  subjects.each do |name|
    name = name.gsub(/\s+/, "")
    zooniverse_id = id_hash[name]
    
    next if zooniverse_id == nil
    
    center_name = name.sub('_F475W', '').sub('_sc', '')
    center = centers[center_name]
    
    row = []
    row << id_hash[name]
    row << name
    row << "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/#{name}.jpg"
    row << "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/#{name}.jpg"
    row << center['ra']
    row << center['dec']
        
    # if centers.has_key?(center_name)
    #   center = centers[center_name]
    #   row << center['ra']
    #   row << center['dec']
    # else
    #   puts center_name
    # end
    
    csv << row
  end
  
end