raise "usage: main.rb FILENAME" if ARGV.size == 0

d1, d2 = [], []
File.readlines(ARGV[0]).map(&:chomp).each do |line|
  v1, v2 = line.split(/\s+/)
  d1 << v1.to_i
  d2 << v2.to_i
end

d1.sort!
d2.sort!
res = 0

d1.each_index do |i|
  res += (d1[i] - d2[i]).abs
end

p res
