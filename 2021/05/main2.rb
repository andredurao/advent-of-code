def debug(map)
  map.each do |line|
    line.each do |item|
      if item == 0 
        print('.')
      else
        print(item)
      end
    end
    print("\n")
  end
end

class Pos
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x.to_i ; @y = y.to_i
  end
end


class Line
  attr_accessor :from, :to
  def initialize(from, to)
    @from = from ; @to = to
    swap if horizontal? && from.x > to.x
    swap if (vertical? || diagonal?) && from.y > to.y
  end

  def max_x
    [from.x, to.x].max
  end

  def max_y
    [from.y, to.y].max
  end

  def min_x
    [from.x, to.x].min
  end

  def min_y
    [from.y, to.y].min
  end


  def fill(map)
    if vertical?
      from.y.upto(to.y){|i| map[i][from.x]+=1}
    elsif horizontal?
      from.x.upto(to.x){|i| map[from.y][i]+=1}
    elsif diagonal?
      diff = to.x - from.x
      x_op = to.x - from.x > 0 ? 1 : -1
      y_op = to.y - from.y > 0 ? 1 : -1
      0.upto(diff.abs)do |i|
        y = from.y+(i*y_op)
        x = from.x+(i*x_op)
        map[y][x]+=1
      end
      #p self
      #debug(map)
    end
  end

  private

  def swap
    @from, @to = @to, @from
  end

  def horizontal?
    from.y == to.y
  end

  def vertical?
    from.x == to.x
  end

  def diagonal?
    delta_x = max_x - min_x
    delta_y = max_y - min_y
    !horizontal? && !vertical? && (delta_x == delta_y)
  end
end

def parse(line)
  m = /(\d+),(\d+) -> (\d+),(\d+)/.match(line)
  from = Pos.new(m[1], m[2]) ; to = Pos.new(m[3], m[4])
  Line.new(from, to)
end

#rows = File.readlines('example', chomp: true)
rows = File.readlines('input', chomp: true)
lines = []
width = height = 0
rows.each do |row|
  line = parse(row)
  lines << line
  width = width < line.max_x ? line.max_x : width
  height = height < line.max_y ? line.max_y : height
end
map = Array.new(height+1, 0){Array.new(width+1, 0)}
lines.each{|line| line.fill(map)}
#debug(map)
total = 0
map.each do |row|
  row.each do |item|
    total +=1 if item >= 2
  end
end
p total
