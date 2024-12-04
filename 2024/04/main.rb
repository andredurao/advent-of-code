raise "usage: main.rb FILENAME" if ARGV.size == 0

charmap = []
File.readlines(ARGV[0]).map(&:chomp).each do |line|
  charmap << line.chars
end

# Part 1
class Solver1
  # ↑↗→↘↓↙←↖
  DIRS = { # I,  J
    '↑' => [-1,  0],
    '↗' => [-1,  1],
    '→' => [ 0,  1],
    '↘' => [ 1,  1],
    '↓' => [ 1,  0],
    '↙' => [ 1, -1],
    '←' => [ 0, -1],
    '↖' => [-1, -1],
  }
  attr_reader :charmap, :set, :width, :height

  def initialize(charmap:)
    @charmap = charmap
    @set = Set.new
    @width = charmap[0].size
    @height = charmap.size
  end

  def valid_pos?(pos)
    pos[0] >= 0 && pos[0] < height && pos[1] >= 0 && pos[1] < width
  end

  def pos_index(pos)
    (pos[0] * height + pos[1]).to_s
  end

  def check
    # x = check_pos([0,4])
    total = 0
    charmap.each_index do |i|
      charmap[i].each_index do |j|
        total += check_pos([i,j])
      end
    end
    total
  end

  def check_pos(pos)
    total = 0
    path = []
    DIRS.each do |dir, inc|
      found, path = xmas?(pos, 0, inc, [])
      if found
        key = path.join(':')
        total += 1 if !set.include?(key)
        set.add(key)
      end
    end
    total
  end

  def xmas?(pos, i, dir, path)
    # puts "xmas: pos: #{pos} i: #{i} dir: #{dir} path: #{path}"

    return [true, path] if i==4

    if !valid_pos?(pos)
      # puts "invalid pos"
      return [false, []]
    end

    path << pos_index(pos)

    if i < 4 && charmap[pos[0]][pos[1]] == 'XMAS'[i]
      new_pos = [pos[0]+dir[0],pos[1]+dir[1]]
      return xmas?(new_pos, i+1, dir, path)
    else
      # puts "wrong char"
      return [false, []]
    end
  end
end


solver = Solver1.new(charmap:)
total = solver.check
puts "part1: #{total}"


# Part 2

class Solver2
  # M_M  M_S  S_S  S_M
  # _A_  _A_  _A_  _A_
  # S_S  M_S  M_M  S_M
  COMBINATIONS = [
    {[0,0] => ?M, [0,2] => ?M, [1,1] => ?A, [2,0] => ?S, [2,2] => ?S},
    {[0,0] => ?M, [0,2] => ?S, [1,1] => ?A, [2,0] => ?M, [2,2] => ?S},
    {[0,0] => ?S, [0,2] => ?S, [1,1] => ?A, [2,0] => ?M, [2,2] => ?M},
    {[0,0] => ?S, [0,2] => ?M, [1,1] => ?A, [2,0] => ?S, [2,2] => ?M},
  ]

  attr_reader :charmap, :set, :width, :height

  def initialize(charmap:)
    @charmap = charmap
    @set = Set.new
    @width = charmap[0].size
    @height = charmap.size
  end

  def valid_pos?(pos)
    pos[0] >= 0 && pos[0] < height && pos[1] >= 0 && pos[1] < width
  end

  def pos_index(pos)
    (pos[0] * height + pos[1]).to_s
  end

  def check
    total = 0
    charmap.each_index do |i|
      charmap[i].each_index do |j|
        if xmas?([i,j])
          total += 1
        end
      end
    end
    total
  end

  def xmas?(pos)
    return false if !valid_pos?([pos[0]+2,pos[1]+2])
    COMBINATIONS.each do |combination|
      c = 0
      combination.each do |inc, ch|
        # puts "ch: #{ch} mch: #{charmap[pos[0]+inc[0]][pos[1]+inc[1]]}"
        break if charmap[pos[0]+inc[0]][pos[1]+inc[1]] != ch
        c += 1
      end
      return true if c == 5
    end
    false
  end
end


solver = Solver2.new(charmap:)
total = solver.check
puts "part2: #{total}"

