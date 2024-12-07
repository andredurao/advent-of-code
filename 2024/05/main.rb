# Part 1

class Solver
  attr_accessor :lines, :pairs, :sequences, :ab_map, :ba_map

  def initialize
    @lines = File.readlines(ARGV[0]).map(&:chomp)
    @pairs = []
    @sequences = []
    @ab_map = {}
    @ba_map = {}

    @pairs.each do |a, b|

    end
    i = 0
    while i < lines.size - 1 do
      if lines[i].size == 0
        i += 1
        break
      end
      @pairs << lines[i].split('|').map(&:to_i)
      i += 1
    end

    while i < lines.size do
      @sequences << lines[i].split(',').map(&:to_i)
      i += 1
    end

    @pairs.each do |a, b|
      @ab_map[a] ||= Set.new ; @ab_map[b] ||= Set.new
      @ab_map[a] += [b]
      @ba_map[b] ||= Set.new ; @ba_map[a] ||= Set.new
      @ba_map[b] += [a]
    end
  end

  def solve
    part1 = 0
    part2 = 0

    @sequences.each do |sequence|
      if valid_sequence?(sequence)
        part1 += sequence[sequence.size/2]
      else
        sorted_sequence = sort(sequence)
        part2 += sorted_sequence[sorted_sequence.size/2] # part 1: 5991 part 2: 5479
      end
    end

    puts "part 1: #{part1}"
    puts "part 2: #{part2}"
  end

  def valid_sequence?(sequence)
    0.upto(sequence.size - 2) do |i|
      if !ab_map[sequence[i]].include?(sequence[i+1])
        return false
        break
      end
    end
    true
  end

  def sort(sequence)
    list = []
    ab_intersect_count_map = {}
    sequence.each do |val|
      ab_intersect_count_map[val] = (ab_map[val] & sequence).size
      list << val if ab_intersect_count_map[val] == 0
    end
    # ab_intersect_count_map will contain
    # key: a value from the sequence
    # value: the amount of values in common with that value and
    # the set of values that are expected to preceed that value

    res = [list[0]]
    while res.size < sequence.size
      last = res[-1]
      # lookup for the values that are expected to preceed the last value, until counts reach zero
      (ba_map[last] & sequence).each do |val|
        ab_intersect_count_map[val] -= 1
        res << val if ab_intersect_count_map[val] == 0
      end
    end

    res
  end
end

raise "usage: main.rb FILENAME" if ARGV.size == 0

solver = Solver.new
solver.solve
