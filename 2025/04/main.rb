raise "usage: main.rb FILENAME" if ARGV.size == 0

DIRECTIONS = [
  [-1,0],
  [-1,1],
  [0,1],
  [1,1],
  [1,0],
  [1,-1],
  [0,-1],
  [-1,-1]
].freeze

def read_map
  File.readlines(ARGV[0]).map{|line| line.chomp.chars }
end

def valid_pos?(map, pos)
  pos[0] >= 0 && pos[0] < map.size && pos[1] >= 0 && pos[1] < map[0].size
end

def neighbours(map, pos)
  return 0 if !valid_pos?(map, pos)

  total = 0
  DIRECTIONS.each do |dir|
    new_pos = [pos[0]+dir[0], pos[1]+dir[1]]
    if valid_pos?(map, new_pos) && map[new_pos[0]][new_pos[1]] == ?@
      total += 1
    end
  end
  total
end

def part1(map)
  res = 0

  height = map.size
  width = map[0].size

  height.times do |i|
    width.times do |j|
      res += 1 if map[i][j] == ?@ && neighbours(map, [i,j]) < 4
    end
  end

  puts "part1: #{res}"
end

def remove_items(map)
  res = 0

  height = map.size
  width = map[0].size
  remove_stack = []

  height.times do |i|
    width.times do |j|
      pos = [i,j]
      remove_stack << pos if map[i][j] == ?@ && neighbours(map, pos) < 4
    end
  end

  remove_stack.each{|pos| map[pos[0]][pos[1]] = ?.}
  [map, remove_stack.size]
end

def print_map(map)
  map.each{|line| puts line.join} ; nil
end

def part2(map)
  res = 0
  while true
    map, qty = remove_items(map)
    res += qty
    break if qty == 0
  end

  puts "part2: #{res}"
end

map = read_map

part1(map)
part2(map)

