class Puzzle
  attr_accessor :template, :polymer, :pairs, :counter
  def initialize(input)
    build_polymer(input)
    build_pairs(input)
  end

  def solve
    count = ARGV[1].to_i || 1
    count.times{ step }
    counter = {} ; counter.default = 0
    @polymer.each do |pair, value|
      l, r = pair.chars
      counter[l] += value
    end
    counter[@template[-1]] += 1
    p @polymer, counter
    values = counter.values
    puts "result = #{(values.max - values.min)}"
  end

  def step
    new_polymer = {} ; new_polymer.default = 0
    @polymer.each do |pair, acc|
      char = @pairs[pair]
      l, r = pair.chars
      left = [l, char].join ; right = [char, r].join 
      new_polymer[left] += acc ; new_polymer[right] += acc
    end
    @polymer = new_polymer
  end

  def build_polymer(input)
    @template = input[0]
    @polymer = {} ; @polymer.default = 0
    0.upto(@template.length - 2) do |index|
      pair = @template[index..index+1]
      @polymer[pair] += 1
    end
  end

  def build_pairs(input)
    @pairs = {}
    input[2..-1].each do |pair|
      from, to = pair.split(' -> ')
      @pairs[from] = to
    end
  end

  def debug
    p @polymer.length
  end
end

input = File.readlines(ARGV[0], chomp: true)
puzzle = Puzzle.new(input)
puzzle.solve
puzzle.debug
# {"N"=>5, "B"=>11, "C"=>5, "H"=>4}
