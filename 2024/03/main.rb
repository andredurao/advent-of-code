raise "usage: main.rb FILENAME" if ARGV.size == 0

# Part 1

total = 0

line = File.read(ARGV[0]).chomp

line.scan(/mul\(\d+\,\d+\)/).each do |cmd|
  m = /mul\((\d+)\,(\d+)\)/.match(cmd)
  total += (m[1].to_i * m[2].to_i)
end

puts "part1: #{total}"

# Part 2

total = 0

token_regex = /mul\(\d+\,\d+\)|do\(\)|don\'t\(\)/
do_mul = true
line.scan(token_regex).each do |cmd|
  do_mul = true if cmd == 'do()'
  do_mul = false if cmd == "don't()"
  if cmd.start_with?('mul') && do_mul
    m = /mul\((\d+)\,(\d+)\)/.match(cmd)
    total += (m[1].to_i * m[2].to_i)
  end
end

puts "part2: #{total}"
