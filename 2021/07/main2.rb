line = File.readlines('input', chomp: true).first
items = line.split(',').map(&:to_i).sort
min = [-1, -1]
dist = ->(x){(x*(x+1))/2}
0.upto(items.max) do |pos|
  total = 0
  items.each do |item|
    diff = item > pos ? (item - pos) : (pos - item)
    total += dist.(diff)
  end
  p [pos, total]
  min = [total, pos] if min[0] == -1 || total < min[0]
end
p min
