class Day06

  attr_reader :worksheet, :lines, :width, :height

  def initialize(filename=ARGV[0])
    raise "usage: main.rb FILENAME" if !filename

    @worksheet = read_file(filename)
    @width = lines[0].size
    @height = lines.size
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
    res = 0
    col = width - 1

    while col > 0
      expression = []
      while col >= 0
        word = ''
        height.times do |row|
          ch = lines[row][col]
          word << ch
        end

        break if word.strip.size == 0
        expression << word

        col -= 1
      end

      current_expression = expression.map{|x| x.scan(/\d+|[\+\-\*\/]/)}.flatten
      current_expression = current_expression.map{|item| convert_str(item)}

      res += current_expression[..-2].reduce(&current_expression[-1])

      col -= 1
    end

    puts "part 2: #{res}"
  end

  private

  def convert_str(str)
    Integer(str)
  rescue ArgumentError
    str.to_sym
  end

  def read_file(filename)
    @lines = []
    worksheet = []
    File.readlines(filename).map(&:chomp).each do |line|
      @lines << line
      items = line.scan(/\w+|[\+\-\/\*]/).map{|item| convert_str(item)}
      worksheet << items
    end
    worksheet
  end
end

app = Day06.new
app.part1
app.part2
