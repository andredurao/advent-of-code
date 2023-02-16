require 'set'
require 'json'

def ordered?(l, r)
  # p l ; p r ; p '- ' * 20
  while l.any? && r.any?
    vl, vr = l.shift, r.shift
    if vl.is_a?(Integer) && vr.is_a?(Integer)
      return true if vl < vr
      return false if vl > vr
    else
      vl = [vl] if !vl.is_a?(Array)
      vr = [vr] if !vr.is_a?(Array)
      result = ordered?(vl, vr)
      return result if [true, false].include?(result)
    end
  end
  # the && ...any? should be present in part1 also
  return true if l.empty? && r.any?
  return false if r.empty? && l.any?
end

def smaller(items)
  index = 0
  1.upto(items.size - 1) do |i|
    v1 = JSON::parse("#{items[index]}")
    v2 = JSON::parse("#{items[i]}")
    index = i if !ordered?(v1, v2)
  end
  index
end

items = [[[2]],[[6]]]
File.readlines(ARGV[0], chomp: true).each do |line|
  if !line.empty?
    items << JSON::parse(line)
  end
end

sorted_items = []
while items.any? do
  index = smaller(items)
  sorted_items << JSON::parse("#{items[index]}")
  items.delete_at(index)
end

indexes = []
sorted_items.each_index do |index|
  indexes << (index + 1) if [[[2]],[[6]]].include?(sorted_items[index])
end

p indexes
p indexes.reduce(:*)
