class Day09

  attr_reader :positions

  def initialize(filename=ARGV[0])
    raise "usage: main.rb FILENAME" if !filename

    @positions = read_file(filename)
  end

  def part1
    res = 0

    positions.combination(2).each do |p1, p2|
      area = ((p1[0] - p2[0]).abs + 1) * ((p1[1] - p2[1]).abs + 1)
      res = [res, area].max
    end

    puts "part 1: #{res}"
  end

  private

  def read_file(filename)
    File.readlines(filename, chomp: true).map do |row|
      row.split(?,).map(&:to_i)
    end
  end
end

app = Day09.new
app.part1
