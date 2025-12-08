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

  def part2
    # sort ranges
    @ranges = ranges.sort{|a,b| a.first <=> b.first}

    compacted_ranges = []
    ranges.each_with_index do |range, i|
      if i == 0
        compacted_ranges << range
      else
        previous_compacted_range = compacted_ranges.last
        # check if range is included in previous compacted range
        if range.first <= previous_compacted_range.last + 1
          # join ranges
          v1 = previous_compacted_range.first
          v2 = [range.last, previous_compacted_range.last].max

          compacted_ranges.pop
          compacted_ranges << (v1..v2)
        else
          compacted_ranges << range
        end
      end
    end

    res = compacted_ranges.reduce(0) {|total, range| total += range.size}
    puts "part2: #{res}"
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
app.part2
