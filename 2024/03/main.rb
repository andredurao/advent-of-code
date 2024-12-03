raise "usage: main.rb FILENAME" if ARGV.size == 0

# Part 1

total = 0

line = File.read(ARGV[0]).chomp

line.scan(/mul\(\d+\,\d+\)/).each do |cmd|
  m = /mul\((\d+)\,(\d+)\)/.match(cmd)
  total += (m[1].to_i * m[2].to_i)
end


puts "part1: #{total}"
