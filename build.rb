#!/usr/bin/env ruby

require 'aws-sdk'

AWS.config access_key_id: ENV['S3_ACCESS_ID'], secret_access_key: ENV['S3_SECRET_KEY']
s3 = AWS::S3.new
bucket = s3.buckets['www.andromedaproject.org/test-deploy']

build = <<-BASH
zoo build
mv build-* build
rm -rf build/utilities
rm -rf build/data
rm build/build.rb
BASH

system build

Dir.chdir 'build'

bucket.objects['index.html'].write file: 'index.html', acl: :public_read, content_type: 'text/html', cache_control: 'no-cache, must-revalidate'
bucket.objects['styles/zooniverse.css'].write file: 'styles/zooniverse.css', acl: :public_read, content_type: 'text/css'
bucket.objects['styles/main.css'].write file: 'styles/main.css', acl: :public_read, content_type: 'text/css'
bucket.objects['scripts/build/main.js'].write file: 'scripts/build/main.js', acl: :public_read, content_type: 'application/javascript'

bucket.objects['images/tutorial/cosmic-rays_color.png'].write file: 'images/tutorial/cosmic-rays_color.png', acl: :public_read
bucket.objects['images/tutorial/cosmic-rays_F475W.png'].write file: 'images/tutorial/cosmic-rays_F475W.png', acl: :public_read
bucket.objects['images/tutorial/edge-field_color.jpg'].write file: 'images/tutorial/edge-field_color.jpg', acl: :public_read
bucket.objects['images/tutorial/edge-field_F475W.jpg'].write file: 'images/tutorial/edge-field_F475W.jpg', acl: :public_read

system "rm -rf build"
puts 'Done!'