class Node
  attr_accessor :value, :visited
  def initialize(value)
    @value = value
    @visited = false
  end

  def visit!
    @visited = true
  end

  def visited?
    @visited
  end
end

class Map
  DIRECTIONS = { up: [-1,0], down: [1,0], left: [0,-1], right: [0,1] }

  def initialize(values)
    @map = build_map(values)
    @height = @map.size
    @width = @map[0].size
  end

  def build_map(values)
    result = []
    values.each do |row|
      result << row.map{|value| Node.new(value)}
    end
    result
  end

  def low_points
    result = []
    0.upto(@height - 1) do |i|
      0.upto(@width - 1) do |j|
        pos = [i,j]
        if low_point?(pos)
          result << pos
        end
      end
    end
    result
  end

  def low_point?(pos)
    current = @map[pos[0]][pos[1]].value
    result = 0
    # p "pos #{pos} current => #{current}"
    DIRECTIONS.each do |dir, delta|
      new_pos = [pos[0] + delta[0], pos[1] + delta[1]]
      if valid?(new_pos)
        actual = @map[new_pos[0]][new_pos[1]].value
        #p "new_pos #{new_pos} actual #{actual}"
        return false if current >= actual
      end
    end
    true
  end

  def valid?(pos)
    pos[0] < @height && pos[0] >= 0 && pos[1] < @width && pos[1] >= 0
  end

  def debug
    @map.each{|row| p(row)}
  end

  def basin_flood(pos, result=[])
    current = @map[pos[0]][pos[1]]
    return if current.value == 9 || current.visited?
    current.visit!
    result << current.value
    DIRECTIONS.each do |dir, delta|
      new_pos = [pos[0] + delta[0], pos[1] + delta[1]]
      basin_flood(new_pos, result) if valid?(new_pos)
    end
    result
  end
end

#lines = File.readlines('example', chomp: true)
lines = File.readlines('input', chomp: true)

values = []
lines.each{|line| values << line.chars.map(&:to_i)}

map = Map.new(values)
low_points = map.low_points
basins = []
low_points.each do |pos|
  basin = map.basin_flood(pos)
  basins << basin.size
end
result = basins.sort[-3..-1]
p result
p result.inject(:*)

