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
    swap if vertical?   && from.y > to.y
  end

  def max_x
    from.x > to.x ? from.x : to.x
  end

  def max_y
    from.y > to.y ? from.y : to.y
  end

  def fill(map)
    if vertical?
      from.y.upto(to.y){|i| map[i][from.x]+=1}
    elsif horizontal?
      from.x.upto(to.x){|i| map[from.y][i]+=1}
    end
    #map.each{|row| p(row)}
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
p height, width
map = Array.new(height+1, 0){Array.new(width+1, 0)}
lines.each{|line| line.fill(map)}
#map.each{|row| p(row)}
total = 0
map.each do |row|
  row.each do |item|
    total +=1 if item >= 2
  end
end
p total
