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
      lines << Line.new(pos1, pos2)
    end

    draw_map(lines)

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
