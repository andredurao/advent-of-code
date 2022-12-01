max = -1
stack = []
File.readlines(ARGV[0]).map(&:chomp).each do |line|
  if line == ''
    max = [max, stack.sum].max
    stack = []
  else
    stack << line.to_i
  end
end
p max
