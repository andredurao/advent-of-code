require 'chunky_png'

class Pos
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Line
  attr_accessor :pos1, :pos2, :direction

  def initialize(pos1, pos2)
    @pos1 = pos1
    @pos2 = pos2
    @direction = pos1.x == pos2.x ? :vertical : :horizontal
  end
end

class Rectangle
  attr_accessor :min, :max

  def initialize(pos1, pos2)
    x = [pos1.x, pos2.x]
    y = [pos1.y, pos2.y]
    @min = Pos.new(x.min, y.min)
    @max = Pos.new(x.max, y.max)
  end

  def to_s
    "(#{min.x},#{min.y})-(#{max.x},#{max.y})"
  end

  def width
    @width ||= max.x - min.x + 1
  end

  def height
    @height ||= max.y - min.y + 1
  end

  def dup
    Rectangle.new(min.dup, max.dup)
  end

  def inset(n)
    inset_rectangle = self.dup
    if width < n * 2
      inset_rectangle.min.x = (min.x + max.x) / 2
      inset_rectangle.max.x = min.x
    else
      inset_rectangle.min.x += n
      inset_rectangle.max.x -= n
    end

    if height < n * 2
      inset_rectangle.min.y = (min.y + max.y) / 2
      inset_rectangle.max.y = min.y
    else
      inset_rectangle.min.y += n
      inset_rectangle.max.y -= n
    end

    inset_rectangle
  end

  def empty?
    min.x >= max.x || min.y >= max.y
  end

  def overlaps?(other)
    return false if empty? || other.empty?

    min.x < other.max.x && other.min.x < max.x &&
    min.y < other.max.y && other.min.y < max.y
  end
end

class Day09

  attr_reader :positions, :width, :height

  def initialize(filename=ARGV[0])
    raise "usage: main.rb FILENAME" if !filename

    read_file(filename)
  end

  def part1
    res = 0

    positions.combination(2).each do |p1, p2|
      area = ((p1[0] - p2[0]).abs + 1) * ((p1[1] - p2[1]).abs + 1)
      res = [res, area].max
    end

    puts "part 1: #{res}"
  end

  def part2
    res = 0

    lines = []
    positions.each_index do |i|
      pos1 = Pos.new(*positions[i])
      index_pos2 = i < (positions.size - 1) ? i+1 : 0
      pos2 = Pos.new(*positions[index_pos2])
      lines << Rectangle.new(pos1, pos2)
    end

    draw_map(lines) if ENV["draw_map"]

    rectangles = []
    positions.combination(2).each do |p1, p2|
      pos1 = Pos.new(*p1)
      pos2 = Pos.new(*p2)
      rectangles << Rectangle.new(pos1, pos2)
    end

    rectangles.each_with_index do |r, i|
      rectangle = r.dup

      area = rectangle.width * rectangle.height

      rectangle.max.x += 1
      rectangle.max.y += 1

      overlap = false

      lines.each_with_index do |l, j|
        line = l.dup
        line.max.x += 1
        line.max.y += 1

        inset = rectangle.inset(1)
        overlap = line.overlaps?(inset)
        if overlap
          break
        end
      end

      res = [res, area].max if !overlap
    end

    puts "part 2: #{res}"
  end

  private

  # Draw a png of the map on scale 1:200
  def draw_map(lines)

    scale = 200
    png = ChunkyPNG::Image.new((width / 200)+20, (height / 200)+20, ChunkyPNG::Color::BLACK)

    lines.each do |line|
      if line.direction == :horizontal
        start = [line.pos1.x, line.pos2.x].min
        finish = [line.pos1.x, line.pos2.x].max
        y = line.pos1.y / 200
        (start/200).upto(finish/200) do |x|
          png[x,y] = ChunkyPNG::Color::WHITE
        end
      else
        start = [line.pos1.y, line.pos2.y].min
        finish = [line.pos1.y, line.pos2.y].max
        x = line.pos1.x / 200
        (start/200).upto(finish/200) do |y|
          png[x,y] = ChunkyPNG::Color::WHITE
        end
      end
    end

    png.save('output.png')
  end

  def read_file(filename)
    x_max = -1
    y_max = -1
    @positions = File.readlines(filename, chomp: true).map do |row|
      x, y = row.split(?,).map(&:to_i)
      x_max = [x_max, x].max
      y_max = [y_max, y].max

      [x, y]
    end

    @width  = x_max
    @height = y_max
  end
end

app = Day09.new
app.part1
app.part2
