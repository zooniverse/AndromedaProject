require 'csv'
require 'bson'

class ZooniverseIdGenerator
  def self.next_id
    @last_id ||= 'AAP0000000'
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

dirname = File.dirname(__FILE__)

csv = CSV::open('andromeda_subjects_with_ids.csv', 'wb')
header = ['_id', 'zooniverse_id', 'subimage']
csv << header

File.open("#{dirname}/../data/andromeda_subjects.txt").each do |line|
  bson_id = BSON::ObjectId.new
  zooniverse_id = ZooniverseIdGenerator.next_id
  subimg = line.strip()
  
  csv << [bson_id, zooniverse_id, subimg]
end

csv.close()