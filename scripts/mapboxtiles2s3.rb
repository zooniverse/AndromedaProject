#!/usr/bin/env ruby

require 'pathname'
require 'sqlite3'
require 'aws/s3'

# Grab the command line arguments
database = ARGV[0]
bucket_name = ARGV[1] || 'www.andromedaproject.org'

root = 'tiles'
brickname = Pathname.new(database).basename
directory = brickname.to_s.split('.')[0]

# Connect to S3
AWS::S3::Base.establish_connection!(
  :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
)
bucket = AWS::S3::Bucket.find(bucket_name)

# Connect and query the MBTiles database
db = SQLite3::Database.new database
tiles = db.execute "SELECT zoom_level, tile_column, tile_row, tile_data FROM tiles;"
tiles.each_with_index do |tile, index|
  zoom, column, row, data = tile
  # puts "#{zoom}, #{column}, #{row}"
  puts zoom, column, row if index % 100 == 0
  
  # # Convert from TMS to XYZ
  # columns = 2 ** zoom - 1
  # row = columns - row
  
  AWS::S3::S3Object.store("#{row}.png", data, "#{bucket_name}/#{root}/#{directory}/#{zoom}/#{column}/")
end