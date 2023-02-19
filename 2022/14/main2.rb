require_relative('../utils/string.rb')

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
      ni, nj = n
      break if [ni, nj] == [i, j]
      @i = ni ; @j = nj
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
    else
      [i, j]
    end
  end
end

# ================================================================

paths = []
File.readlines(ARGV[0], chomp: true).each do |line|
  items = line.split(' -> ').map{|pos| pos.split(',').map(&:to_i)}
  paths << items
end

map = Array.new(185) { Array.new(700) { '.' } }

draw(map, paths)

max_y = -1
paths.each do |positions|
  positions.each do |x,y|
    max_y = max_y == -1 ? y : [max_y, y].max
  end
end

# binding.irb ; exit 0

0.upto(699){|j| map[max_y + 2][j] = '#'}

count = 0
while true do
  grain = Grain.new(map, [500,0])
  i, j = grain.move
  # map[i][j] = 'o'.green
  map[i][j] = 'o'
  count += 1
  if ENV['DEBUG']
    puts `clear`
    print_map(map, [480,0], [520, 15])
    sleep 0.1
  end
  if i == 0
    p [i,j]
    break
  end
end

p count
