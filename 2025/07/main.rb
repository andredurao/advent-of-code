class Day07

  attr_reader :lines, :height, :width, :starting_point

  def initialize(filename=ARGV[0])
    raise "usage: main.rb FILENAME" if !filename

    read_file(filename)
    @starting_point = lines[0].index(?S)
    @width = lines[0].size
    @height = lines.size
  end

  def part1
    res = 0
    rays = []
    lines.each_with_index do |line, i|
      if i == 0
        rays = [starting_point]
      else
        new_rays = []

        splits(line).each do |split|
          if rays.include?(split)
            res += 1
            # left
            new_rays << split-1 if split > 0 && line[split-1] == ?.
            # right
            new_rays << split+1 if split < width-1 && line[split+1] == ?.
          end
        end

        rays.each{|ray| new_rays << ray if lines[i][ray] == ?.}
        new_rays.each{|ray| line[ray] = ?|}
        rays = new_rays.dup
        # puts line
      end
    end

    puts "part 1: #{res}"
  end

  private

  def read_file(filename)
    @lines = File.readlines(filename).map(&:chomp)
  end

  def splits(line)
    indexes = []
    line.chars.each_with_index{|ch, i| indexes << i if ch == ?^}
    indexes
  end
end

app = Day07.new
app.part1
