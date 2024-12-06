raise "usage: main.rb FILENAME" if ARGV.size == 0

# Part 1

a_b_map = {}
i = 0
lines = File.readlines(ARGV[0]).map(&:chomp)
# order values
while i < lines.size - 1 do
  if lines[i].size == 0
    i += 1
    break
  end

  a, b = lines[i].split('|').map(&:to_i)
  a_b_map[a] ||= Set.new ; a_b_map[b] ||= Set.new
  a_b_map[a] += [b]
  i += 1
end

# page sequences
total = 0

while i < lines.size - 1 do
  l = lines[i].split(',').map(&:to_i)
  valid = true
  0.upto(l.size - 2) do |j|
    if !a_b_map[l[j]].include?(l[j+1])
      valid = false
      break
    end
  end
  total += l[l.size/2] if valid

  i += 1
end

puts "part1: #{total}"
