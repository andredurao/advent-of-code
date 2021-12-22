class Puzzle
  attr_accessor :x_range, :y_range, :pos, :speeds

  def initialize(input)
    m = /x=(-?\d+)\.\.(-?\d+)/.match(input)
    min_x, max_x = m[1..2].map(&:to_i)
    @x_range = min_x..max_x
    m = /y=(-?\d+)\.\.(-?\d+)/.match(input)
    min_y, max_y = m[1..2].map(&:to_i)
    @y_range = min_y..max_y
  end

  def solve
    results = []
    total = 0
    1000.times do |x|
      -1000.upto(1000) do |y|
        pos = [x,y]
        #p pos
        result, pos, max = hit(pos)
        if result
          #p "boom", pos
          total += 1 
        end
      end
    end
    p total
  end

  def hit(speeds)
    @pos = [0,0]
    @speeds = speeds
    max_y = -1
    i = 0
    while true
      step(i)
      #p [ @pos, @speeds ]
      x, y = @pos
      max_y = y if y > max_y
      if x > @x_range.last || y < @y_range.first
        return [false, @pos, -1]
      end
      if @x_range.include?(x) && @y_range.include?(y)
        #puts "boom #{@pos}, #{i + 1}"
        return [true, @pos, max_y]
      end
      i += 1
    end
  end

  def step(n)
    if n > 0
      @speeds[0] -= 1 if @speeds[0] > 0
      @speeds[1] -= 1
    end
    @pos = [
      @pos[0] + @speeds[0],
      @pos[1] + @speeds[1],
    ]
  end

  def debug
    p x_range
    p y_range
  end
end

lines = File.readlines(ARGV[0], chomp: true)
puzzle = Puzzle.new(lines[0])
puzzle.solve
