total = 0

def range(str)
  start, finish = str.split('-').map(&:to_i)
  Array(start..finish)
end

File.readlines(ARGV[0]).each do |line|
  l_range, r_range = line.chomp.split(',')
  l = range(l_range)
  r = range(r_range)
  intersect = l & r
  total += 1 if intersect.any?
end

p total
