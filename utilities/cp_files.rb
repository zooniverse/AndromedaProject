# Script to copy (move) BW images to separate directory on S3

dirname = File.dirname(__FILE__)
ap_subjects = File.join(dirname, "..", "data", "all_subjects.txt")

File.open(ap_subjects, 'r') do |f|
  while (line = f.gets)
    match = /.*_F475W/.match line
    if match
      puts match
      
      identifier = match.to_s.gsub '_F475W', ''
      
      standard_url = "s3://www.andromedaproject.org/subjects/standard/#{match}.jpg"
      f475_url = "s3://www.andromedaproject.org/subjects/F475W/#{identifier}.jpg"
      `s3cmd cp #{standard_url} #{f475_url}`
    end
  end
end