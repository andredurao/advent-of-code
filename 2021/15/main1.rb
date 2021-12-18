require 'set'
class Puzzle
  DIRECTIONS = { up: [0,-1], down: [0,1], left: [-1,0], right: [1,0] }
  attr_accessor :map, :unvisited, :distances

  def initialize(input)
    build_map(input)
    build_unvisited
    build_distances
  end

  # dijkstra https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
  def solve
    start = [0,0] ; finish = [width - 1, height - 1]
    current = start
    path = []
    while !@unvisited.empty? && current != finish
      @unvisited.delete(current)
      neighbours(current).each do |pos|
        if @unvisited.include?(pos)
          distance = @distances[current] + @map[pos[1]][pos[0]]
          @distances[pos] = distance if distance < @distances[pos]
        end
      end
      current = next_candidate
    end
    p @distances[finish]
  end

  def next_candidate
    pos = nil
    min = Float::INFINITY
    node = nil
    @unvisited.each do |pos|
      distance = @distances[pos]
      if distance < min
        node = pos
        min = distance
      end
    end
    node
  end

  def neighbours(pos)
    x, y = pos
    result = []
    DIRECTIONS.each do |_, dir|
      neighbour = [x + dir[0], y + dir[1]]
      result << neighbour if valid?(neighbour)
    end
    result
  end

  def build_map(input)
    @map = []
    input.each{|line| map << line.chars.map(&:to_i)}
    @map[0][0] = 0
  end

  def height ; @map.size ; end

  def width ; @map[0].size ; end

  def valid?(pos)
    pos[0] >= 0 && pos[1] >= 0 && pos[0] < height && pos[1] < width
  end

  def build_unvisited
    @unvisited = Set.new
    width.times do |x|  
      height.times do |y|
        @unvisited << [x,y]
      end
    end
  end

  def build_distances
    @distances = @unvisited.map{|pos| [pos, Float::INFINITY]}.to_h
    @distances[[0,0]] = 0
  end

  def debug
    @map.each do |row|
      puts row.join("\t")
    end
    puts "-" * 50
  end
end

input = File.readlines(ARGV[0], chomp: true)
puzzle = Puzzle.new(input)
#puzzle.debug
puzzle.solve
