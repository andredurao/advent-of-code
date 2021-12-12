class Node
  attr_accessor :visited, :flashed, :value
  def initialize(value)
    @value = value
    @visited = false
    @flashed = false
  end

  def visit! ; @visited = true ; end
  def flash! ; @flashed = true ; end
  def reset! ; @visited = false ; @flashed = false ; end
  def flashed? ; @flashed ; end
  def inc! ; @value += 1 ; end
  def normalize!
    @visited = false
    @flashed = false
    @value = 0 if @value > 9
  end
end

class Puzzle
  NEIGHBOURS = [ [-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1] ]
  attr_accessor :map, :height, :weight, :flash_counter

  def initialize(map)
    @flas
    @map = map
    @height = map.size
    @width = map[0].size
    @flash_counter = 0
  end

  def iterate(&block)
    0.upto(@height - 1) do |i|
      0.upto(@width -1) do |j|
        yield(i, j)
      end
    end
  end

  def step
    @visited = {}
    iterate do |i, j|
      @map[i][j].inc!
    end
    flashes
    normalize
  end

  def flashes
    queue = flash_queue
    while !queue.empty?
      queue.each{|pos| flash(pos)}
      queue = flash_queue
    end
  end

  def flash_queue
    result = []
    iterate do |i, j|
      node = map[i][j]
      result << [i,j] if !node.flashed? && node.value > 9
    end
    result
  end

  def flash(pos)
    i, j = pos
    node = map[i][j]
    node.flash!
    @flash_counter += 1
    NEIGHBOURS.each do |delta|
      di, dj = delta
      ni = i+di
      nj = j+dj
      if valid?([ni, nj])
        @map[ni][nj].inc!
        flash([ni,nj]) if !node.flashed? && node.value > 9
      end
    end
  end

  def normalize
    iterate do |i, j|
      @map[i][j].normalize!
    end
  end

  def valid?(pos)
    pos[0] < @height && pos[0] >= 0 && pos[1] < @width && pos[1] >= 0
  end

  def debug
    @map.each {|row| puts row.map(&:value).join('')}
  end
end

lines = File.readlines(ARGV[0], chomp: true)
map = lines.reduce([]) {|memo, cur| memo << cur.chars.map(&:to_i).map{|x| Node.new(x)} }

puzzle = Puzzle.new(map)
ARGV[1].to_i.times{ puzzle.step }
p puzzle.flash_counter
