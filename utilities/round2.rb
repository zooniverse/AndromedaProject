
require 'bson'

# Base ID for Andromeda Project subjects
@base_id = '50b781761a320e4aac'

# Offset index to the nth + 1 subject (i.e. 12425 subjects in round 1)
@index = 12426

def next_id
  BSON::ObjectId("#{ @base_id }#{ @index.to_s(16).rjust(6, '0') }").tap{ @index += 1 }
end

class ZooniverseIdGenerator
  def self.next_id
    @last_id ||= 'AAP00009l5'
    @last_id = increment_zoo_id
  end
  
  def self.increment_zoo_id
    id = @last_id.dup
    id.reverse.each_char.with_index do |b, pos|
      if b == '9'
        id[-pos - 1] = 'a'
        return id
      elsif b == ?z
        id[-pos - 1] = '0'
      else
        id[-pos - 1] = b.next.chr
        return id
      end
    end
  end
end

@data_path = File::join(File.dirname(__FILE__), '..', 'data')

phat_subjects = Dir["#{ @data_path }/jpg_final_2/*.jpg"]
phat_synthetics = Dir["#{ @data_path }/jpg_fcz2/*.jpg"]
archival_subjects = Dir["#{ @data_path }/jpg_strip/*.jpg"]
archival_synthetics = []

phat_subjects.map! { |subject| File.basename(subject, '.jpg') }
phat_synthetics.map! { |subject| "#{File.basename(subject, '.jpg')}_sc" }
archival_subjects.map! { |subject| File.basename(subject, '.jpg') }

subjects = phat_subjects.concat(phat_synthetics)
subjects.sort!

subjects.each do |subject|
  puts "#{subject}, #{ZooniverseIdGenerator.next_id}, #{next_id}"
end