def log(x)
  p(x) if ENV['DEBUG']
end

def find_marker(line)
  i = 0
  while i < line.length
    block = line[i..i+3]
    log(block)
    return i + 4 if block.chars.tally.values.all?{|x| x == 1}
    i += 1
  end
  0
end

line = File.readlines(ARGV[0]).first.chomp
p find_marker(line)

