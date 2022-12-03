chars = Array('a'..'z') + Array('A'..'Z')
priorities = {}
chars.each_with_index{|c,i| priorities[c] = i+1}

def shared(str)
  mid = str.size / 2
  l = str[0...mid].chars
  r = str[mid..-1].chars
  (l & r).first
end

total = 0

File.readlines(ARGV[0]).each do |line|
  char = shared(line.chomp)
  total += priorities[char]
end

p total
