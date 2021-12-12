class Map
  def initialize(map)
    @map = map
    @height = map.size
    @width = map[0].size
  end

  def low_points
    result = []
    0.upto(@height - 1) do |i|
      0.upto(@width - 1) do |j|
        pos = [i,j]
        height = @map[i][j]
        if low_point?(pos)
          result << (height + 1)
        end
      end
    end
    result
  end


  def low_point?(pos)
    directions = { up: [-1,0], down: [1,0], left: [0,-1], right: [0,1] }
    current = @map[pos[0]][pos[1]]
    result = 0
    # p "pos #{pos} current => #{current}"
    directions.each do |dir, delta|
      new_pos = [pos[0] + delta[0], pos[1] + delta[1]]
      if valid?(new_pos)
        actual = @map[new_pos[0]][new_pos[1]]
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
end

#lines = File.readlines('example', chomp: true)
lines = File.readlines('input', chomp: true)

values = []
lines.each{|line| values << line.chars.map(&:to_i)}

map = Map.new(values)
# map.debug
p map.low_points.inject(:+)

