require 'json'
require 'bson'
require 'aws-sdk'

@data_path = File::join(File.dirname(__FILE__), '..', 'data')

# Setup S3 connection
AWS.config access_key_id: ENV['S3_ACCESS_ID'], secret_access_key: ENV['S3_SECRET_KEY']
@s3 = AWS::S3.new
@bucket = @s3.buckets['www.andromedaproject.org']

def upload(path, type, synthetic)
  basename = File.basename(path, '.jpg')
  basename.gsub!('_F475W', '')
  basename.gsub!('_F555W', '')
  
  puts "subjects/#{type}/#{ basename }.jpg"
  
  obj = @bucket.objects["subjects/#{type}/#{ basename }.jpg"]
  obj.write(file: path, acl: :public_read)
end

def upload_thumbnail(path, type, synthetic)
  basename = File.basename(path, '.jpg')
  basename += '_sc' if synthetic
  basename.gsub!('_F475W', '')
  basename.gsub!('_F555W', '')
  
  puts "subjects/thumbnail/#{ basename }.jpg"
  obj = @bucket.objects["subjects/thumbnail/#{ basename }.jpg"]
  
  # Create thumbnail
  `convert #{path} -resize 25% thumbnail.png`
  obj.write(file: 'thumbnail.png', acl: :public_read)
  `rm thumbnail.png`
end

trouble = []

phat_subjects = Dir["#{ @data_path }/jpg_final_2/*.jpg"]
phat_synthetics = Dir["#{ @data_path }/jpg_fcz2/*.jpg"]
archival_subjects = Dir["#{ @data_path }/jpg_strip/*.jpg"]

phat_subjects.each.with_index do |path, file_index|
  basename = File.basename(path)
  type = basename.include?('F475W') ? 'inverted' : 'standard'
  
  begin
    puts "Uploading #{ file_index + 1 } / #{ phat_subjects.length }"
    upload(path, type, false)
    upload_thumbnail(path, type, false) if type == 'standard'
  rescue
    trouble.push basename
    next
  end
  
end

phat_synthetics.each.with_index do |path, file_index|
  basename = File.basename path
  type = basename.include?('F475W') ? 'inverted' : 'standard'
  
  begin
    puts "Uploading #{ file_index + 1 } / #{ phat_synthetics.length }"
    upload(path, type, true)
    upload_thumbnail(path, type, true) if type == 'standard'
  rescue
    trouble.push basename
    next
  end
  
end

archival_subjects.each.with_index do |path, file_index|
  basename = File.basename(path)
  type = basename.include?('F555W') ? 'inverted' : 'standard'
  
  begin
    puts "Uploading #{ file_index + 1 } / #{ archival_subjects.length }"
    upload(path, type, false)
    upload_thumbnail(path, type, false) if type == 'standard'
  rescue
    trouble.push basename
    next
  end
  
end


puts trouble
