class Puzzle
  attr_accessor :polymer, :pairs, :counter
  def initialize(input)
    build_polymer(input)
    build_pairs(input)
  end

  def solve
    count = ARGV[1].to_i || 1
    count.times{ step }
    counter = {}
    @polymer.chars.each do |char|
      counter[char] ||= 0
      counter[char] += 1
    end
    p counter
    values = counter.values
    puts "result = #{(values.max - values.min)}"
  end

  def step
    inserts = {}
    0.upto(@polymer.length - 2) do |index|
      pair = @polymer[index..index+1]
      insert = @pairs[pair]
      inserts[index] = insert if insert
    end
    inserts = inserts.sort
    new_polymer = []
    cursor = 0
    # build new polymer
    expected = polymer.length + inserts.size
    while new_polymer.length < expected do
      new_polymer << @polymer[cursor]
      insert = inserts.find{|item| item[0] == cursor}
      if insert
        new_polymer << insert[1]
        inserts.delete_if{|item| item[0] == cursor}
      end
      cursor += 1
    end
    @polymer = new_polymer.join
  end

  def build_polymer(input)
    @polymer = input[0]
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
