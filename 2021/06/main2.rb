line = File.readlines('input', chomp: true).first
items = line.split(',').map(&:to_i).sort
map = {}
0.upto(8){|i| map[i] = 0}
items.each do |timer|
  map[timer] += 1
end
def iter(map)
  new_fish = map[0]
  [0, 1, 2, 3, 4, 5, 6, 7].each do |i|
    map[i] = map[i+1]
  end
  map[8] = new_fish
  map[6] += new_fish
end
p map
1.upto(256) do 
  iter(map)
end
p map.values.inject(:+)
