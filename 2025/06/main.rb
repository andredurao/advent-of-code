class Day06

  attr_reader :worksheet

  def initialize(filename=ARGV[0])
    raise "usage: main.rb FILENAME" if !filename

    @worksheet = read_file(filename)
  end

  def part1
    rows = worksheet.size
    cols = worksheet[0].size

    res = 0
    cols.times do |col|
      expression = []
      (rows - 1).times {|row| expression << worksheet[row][col]}
      operator = worksheet[-1][col]
      res += expression.reduce(&operator)
    end
    puts "part 1: #{res}"
  end

  def part2
  end

  private

  def convert_str(str)
    Integer(str)
  rescue ArgumentError
    str.to_sym
  end

  def read_file(filename)
    worksheet = []
    File.readlines(filename).map(&:chomp).each do |line|
      items = line.scan(/\w+|[\+\-\/\*]/).map{|item| convert_str(item)}
      worksheet << items
    end
    worksheet
  end
end

app = Day06.new
app.part1
