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

def find(s, e, map)
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
      return step
    end
    neighbours(current, map).each do |pos|
      if !visited.include?(pos)
        visited.add(pos)
        queue << [pos, step + 1]
      end
    end
  end
end

map = []
starts = []
e = nil
i = 0
File.readlines(ARGV[0], chomp: true).each do |line|
  map << line.chars

  map[i].each_with_index do |char, j|
    e = [i,j] if char == 'E'
    starts << [i,j] if %w[a S].include?(char)
  end

  i += 1
end

smallest = Float::INFINITY
starts.each do |s|
  res = find(s, e, map)
  if res
    smallest = [smallest, res].min
  end
end
p smallest
