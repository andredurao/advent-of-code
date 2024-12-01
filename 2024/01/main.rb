raise "usage: main.rb FILENAME" if ARGV.size == 0

d1, d2 = [], []
File.readlines(ARGV[0]).map(&:chomp).each do |line|
  v1, v2 = line.split(/\s+/)
  d1 << v1.to_i
  d2 << v2.to_i
end

sd1 = d1.sort
sd2 = d2.sort
res = 0

sd1.each_index do |i|
  res += (sd1[i] - sd2[i]).abs
end

p "part1: #{res}"

# Part 2

dc2 = sd2.tally
res = 0

d1.each do |val, _|
  res += val * dc2[val] if dc2[val]
end

p "part2: #{res}"
