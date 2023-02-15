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

def list_items(items)
  p '- ' * 40
  items.each{|item| p item}
  p '- ' * 40
end

items = [[[2]],[[6]]]
File.readlines(ARGV[0], chomp: true).each do |line|
  if !line.empty?
    items << JSON::parse(line)
  end
end

sorted_items = []
# selection sort
while items.any?
  cursor_index = 0
  # json parse hack to deep dup arrays
  cursor = JSON::parse("#{items[0]}")
  list_items(items)
  1.upto(items.size - 1) do |j|
    current = JSON::parse("#{items[j]}")
    if !ordered?(cursor.dup, current.dup)
      cursor = current
      cursor_index = j
    end
  end
  sorted_items << JSON::parse("#{items[cursor_index]}")
  items.delete_at(cursor_index)
end

list_items(sorted_items)
