require 'set'
require 'json'

def ordered?(l, r)
  # p l ; p r ; p r_level ; p '- ' * 20
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
  return true if l.empty?
  return false if r.empty?
end


items = []
File.readlines(ARGV[0], chomp: true).each do |line|
  if !line.empty?
    items << JSON::parse(line)
  end
end

# l, r = items.shift(2)
# p "compare: #{compare(l,r)}"

total = 0
indexes = Array(0...items.size)
pairs = indexes.each_slice(2)
pairs.each_with_index do |pair, index|
  l, r = pair
  if ordered?(items[l],items[r])
    p(index+1)
    total += (index + 1)
  end
end

p total




