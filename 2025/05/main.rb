class Day05

  attr_reader :ranges, :ingredients

  def initialize(filename=ARGV[0])
    raise "usage: main.rb FILENAME" if !filename

    @ranges, @ingredients = read_file(filename)
  end

  def part1
    res = 0
    ingredients.each do |ingredient|
      ranges.each do |range|
        if range.include?(ingredient)
          res += 1
          break
        end
      end
    end
    puts "part1: #{res}"
  end

  private

  def read_file(filename)
    ranges = []
    ingredients = []
    File.readlines(filename).map(&:chomp).each do |line|
      if /\d+\-\d+/.match?(line)
        ranges << Range.new(*line.split(?-).map(&:to_i))
      elsif /\d+/.match?(line)
        ingredients << line.to_i
      end
    end
    [ranges, ingredients]
  end
end

app = Day05.new
app.part1
