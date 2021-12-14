class Puzzle
  attr_accessor :map, :folds
  def initialize(lines)
    build_dots(lines)
    build_folds(lines)
  end

  def solve
    p [ width, height, count ]
    #fold(@folds[0])
    @folds.each{|command| fold(command)}
    [ width, height, count ]
  end

  def count
    @map.size
  end

  def fold(command)
    command['fold along '] = ''
    direction, value = command.split('=')
    value = value.to_i
    @map = send("fold_#{direction}".to_sym, value)
  end

  def fold_y(value)
    result = []
    items = @map.delete_if{|dot| dot[1] == value}
    items.each do |dot|
      if dot[1] > value
        cur_y = dot[1]
        distance = (cur_y - value) * 2
        new_dot = [dot[0], (cur_y - distance)]
        result << new_dot
      else
        result << dot
      end
    end
    result.uniq
  end

  def fold_x(value)
    result = []
    items = @map.delete_if{|dot| dot[0] == value}
    items.each do |dot|
      if dot[0] > value
        cur_x = dot[0]
        distance = (cur_x - value) * 2
        new_dot = [(cur_x - distance), dot[1]]
        result << new_dot
      else
        result << dot
      end
    end
    result.uniq
  end

  def build_dots(lines)
    filtered_lines = lines.filter{|line| /\d+,\d+/ === line}
    @map = filtered_lines.map{|line| line.split(',').map(&:to_i)}
  end

  def build_folds(lines)
    @folds = lines.filter{|line| /fold along .*/ === line}
  end

  def width ; @map.map{|x| x[0]}.max + 1 ; end
  def height ; @map.map{|x| x[1]}.max + 1; end
  def debug
    result = []
    height.times { result << Array.new(width, '.') }
    p height, width
    @map.each{|dot| result[dot[1]][dot[0]] = '#'}
    result.each{|row| puts(row.join)}
  end
end

lines = File.readlines(ARGV[0], chomp: true)
puzzle = Puzzle.new(lines)
p puzzle.solve
puzzle.debug
