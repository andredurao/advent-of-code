require 'set'

def log(x)
  puts(x) if ENV['DEBUG']
end

DIRS = [[1, 0], [-1,0], [0, 1], [0, -1]]
VALUES = Array('a'..'z').map{|x| [x, x.ord - 'a'.ord]}.to_h
VALUES['S'] = 0
VALUES['E'] = VALUES['z']

def valid?(from, to, map)
  height = map.size ; width = map[0].size
  return false if !(0...height).include?(to[0]) || !(0...width).include?(to[1])
  from_value = VALUES[map[from[0]][from[1]]]
  to_value = VALUES[map[to[0]][to[1]]]
  (to_value - from_value) <= 1
end

def neighbours(from, map)
  i, j = from
  result = []
  DIRS.each do |dir|
    to = [i + dir[0], j + dir[1]]
    result << to if valid?(from, to, map)
  end
  result
end

map = []
s = nil
e = nil
i = 0
File.readlines(ARGV[0], chomp: true).each do |line|
  map << line.chars

  index = map[i].index('S')
  s = [i, index] if index
  index = map[i].index('E')
  e = [i, index] if index

  i += 1
end

height = map.size ; width = map[0].size
visited = Set.new(s)
distances = {}
queue = [[s,0]]
current = s
count = 0
while queue.any?
  count += 1
  current, step = queue.shift
  if map[current[0]][current[1]] == 'E'
    puts 'FOUND'
    puts step
    exit 0
  end
  neighbours(current, map).each do |pos|
    if !visited.include?(pos)
      visited.add(pos)
      queue << [pos, step + 1]
    end
  end
end
