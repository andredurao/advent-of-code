require 'set'
class Puzzle
  DIRECTIONS = { up: [0,-1], down: [0,1], left: [-1,0], right: [1,0] }
  attr_accessor :map, :unvisited, :distances, :visited
  attr_reader :width, :height

  def initialize(input)
    build_map(input)
    @height = @map.size
    @width = @map[0].size
    build_unvisited
    build_distances
    @candidates = Set.new
  end

  # dijkstra https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
  def solve
    start = [0,0] ; finish = [width - 1, height - 1]
    current = start
    path = []
    puts "qty = #{width * height}"
    while !@unvisited.empty? && current != finish
      @unvisited.delete(current)
      @candidates.delete(current)
      #if current[0] % 10 == 0 && current[1] % 10 == 0
      #  puts "#{current} / #{@unvisited.size}"
      #end
      neighbours(current).each do |pos|
        if @unvisited.include?(pos)
          distance = @distances[current] + @map[pos[1]][pos[0]]
          @distances[pos] = distance if distance < @distances[pos]
          @candidates << pos
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
    @candidates.each do |pos|
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
    template = []
    input.each{|line| template << line.chars.map(&:to_i)}
    h = template.size ; w = template[0].size

    @map = []
    (5 * h).times{ @map << Array.new(5 * w, 0) }
    5.times do |i|
      5.times do |j|
        adder = i + j
        h.times do |hi|
          w.times do |hj|
            @map[h*i+hi][w*j+hj] = normalize(template[hi][hj] + adder)
          end
        end
      end
    end
  end

  def normalize(value)
    value < 10 && value || value % 9
  end


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
      puts row.join
    end
    puts "-" * 50
  end
end

input = File.readlines(ARGV[0], chomp: true)
puzzle = Puzzle.new(input)
#puzzle.debug
puzzle.solve
