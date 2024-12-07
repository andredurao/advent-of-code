class Solver
  attr_reader :grid, :w, :h, :pos, :dir, :steps

  #       up      right  down   left
  DIRS = [[-1,0], [0,1], [1,0], [0,-1]]

  def initialize
    @grid = []
    File.readlines(ARGV[0]).map(&:chomp).each do |line|
      @grid << line.chars
    end
    @h = @grid.size
    @w = @grid[0].size
    @pos = initial_pos
    @dir = 0 #up
    @steps = 0
  end

  def valid_pos?(pos)
    pos[0] >= 0 && pos[0] < h && pos[1] >= 0 && pos[1] < w
  end

  def initial_pos
    grid.each_with_index do |row, i|
      row.each_with_index do |ch, j|
        return [i,j] if ch == ?^
      end
    end
  end

  def next_pos
    [pos[0]+DIRS[dir][0], pos[1]+DIRS[dir][1]]
  end

  def obstruction?
    return false if !valid_pos?(next_pos)
    grid[next_pos[0]][next_pos[1]] == ?#
  end

  def turn
    @dir = (dir + 1) % 4
  end

  def walk
    turn if obstruction?
    if grid[pos[0]][pos[1]] != ?X
      @steps += 1
      grid[pos[0]][pos[1]] = ?X
    end
    @pos = next_pos
  end

  def solve
    while valid_pos?(pos)
      walk
    end
    puts "part1: #{steps}"
  end

  def debug
    guard_ch = %w[↑ → ↓ ←]
    grid.each_with_index do |row, i|
      str = ''
      row.each_with_index do |ch, j|
        str << ([i,j] == pos ? guard_ch[dir] : grid[i][j])
      end
      puts str
    end
  end
end

raise "usage: main.rb FILENAME" if ARGV.size == 0

solver = Solver.new
solver.solve
