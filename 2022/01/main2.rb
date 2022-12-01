elves = []
current = 0
File.readlines(ARGV[0]).each do |line|
  current += line.to_i if line.chomp! != ''
  if line == ''
    elves << current
    current = 0
  end
end
p elves.sort[-3..-1].sum
