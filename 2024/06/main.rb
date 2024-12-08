class Solver
  attr_reader :grid, :w, :h

  #       up      right  down   left
  DIRS = [[-1,0], [0,1], [1,0], [0,-1]]

  def initialize
    load_grid
  end

  def load_grid
    @grid = []
    File.readlines(ARGV[0]).map(&:chomp).each do |line|
      @grid << line.chars
    end
    @h = @grid.size
    @w = @grid[0].size
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
    raise 'initial pos could not be found'
  end

  def get_next_pos(pos, dir)
    [pos[0]+DIRS[dir][0], pos[1]+DIRS[dir][1]]
  end

  def pos_index(pos)
    pos[0] * h + pos[1]
  end

  def obstruction?(pos, dir)
    next_pos = get_next_pos(pos, dir)
    return false if !valid_pos?(next_pos)
    grid[next_pos[0]][next_pos[1]] == ?#
  end

  def turn(dir)
    (dir + 1) % 4
  end

  def walk(pos, dir, steps)
    dir = turn(dir) if obstruction?(pos, dir)
    if grid[pos[0]][pos[1]] != ?X
      grid[pos[0]][pos[1]] = ?X
      steps += 1
    end
    [get_next_pos(pos, dir), dir, steps]
  end

  def solve1
    pos = initial_pos
    dir = 0 #up
    res = 0
    while valid_pos?(pos)
      pos, dir, res = walk(pos, dir, res)
    end
    puts "part1: #{res}"
  end

  def visit(grid, start_pos, dir, visits_map)
    # debug(pos, dir)
    visits_map[:level] ||= 0
    visits_map[:level] += 1

    set = Set.new
    total = 0

    while true
      pos = get_next_pos(start_pos, dir)

      return total if !valid_pos?(pos)

      if grid[pos[0]][pos[1]] == ?#
        dir = turn(dir)
        next
      end

      index = pos_index(pos).to_s
      if visits_map[:level] == 1 && !set.include?(index)
        grid[pos[0]][pos[1]] = ?#
        r = visit(grid, start_pos, dir, visits_map.dup)
        # puts "found: #{pos} #{dir}" if r > 0
        total += r
        grid[pos[0]][pos[1]] = ?.
      end

      start_pos = pos.dup
      set.add(index)

      # if the index was used twice in the same direction, that's a loop
      index += ":#{dir}"
      return 1 if visits_map[index]
      visits_map[index] = 1
    end
  end

  def solve2
    load_grid
    og_grid = @grid.map(&:dup)
    pos = initial_pos
    r = visit(og_grid, pos, 0, {})

    puts "part2: #{r}"
  end

  def debug(pos, dir)
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
solver.solve1
solver.solve2
