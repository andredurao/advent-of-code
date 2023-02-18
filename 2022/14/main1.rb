def limit_values(paths)
  min_x = -1 ; min_y = -1 ; max_x = -1 ; max_y = -1
  paths.each do |positions|
    positions.each do |x,y|
      min_x = min_x == -1 ? x : [min_x, x].min
      min_y = min_y == -1 ? y : [min_y, y].min
      max_x = max_x == -1 ? x : [max_x, x].max
      max_y = max_y == -1 ? y : [max_y, y].max
    end
  end
  [min_x, min_y, max_x, max_y]
end

def print_map(map, pos1, pos2)
  p '- ' * 50
  pos1[1].upto(pos2[1]) do |i|
    puts map[i][pos1[0]..pos2[0]].join
  end
end

def draw(map, paths)
  paths.each do |path|
    prev = nil
    path.each do |x,y|
      if prev
        px, py = prev
        [px,x].min.upto([px,x].max) do |j|
          [py,y].min.upto([py,y].max) do |i|
            map[i][j] = '#'
          end
        end
      end
      prev = [x,y]
    end
  end
end

# ================================================================

class Grain
  attr_accessor :map, :i, :j
  def initialize(map, pos)
    @map = map
    @j, @i = pos
  end

  def move
    while n = next_pos
      @i, @j = n
      break if @i >= 180
    end
    [i,j]
  end

  def next_pos
    if map[i + 1][j] == '.'
      [i+1, j]
    elsif map[i + 1][j - 1] == '.'
      [i+1, j - 1]
    elsif map[i + 1][j + 1] == '.'
      [i+1, j + 1]
    end
  end
end

# ================================================================

paths = []
File.readlines(ARGV[0], chomp: true).each do |line|
  items = line.split(' -> ').map{|pos| pos.split(',').map(&:to_i)}
  paths << items
end

map = Array.new(185) { Array.new(600) { '.' } }

draw(map, paths)

# print_map(map, [490,0], [510, 10])

count = 0
while true do
  grain = Grain.new(map, [500,0])
  i, j = grain.move
  break if i >= 180
  map[i][j] = 'o'
  count += 1
  if ENV['DEBUG']
    puts `clear`
    print_map(map, [490,0], [510, 10])
    sleep 0.1
  end
end

p count
