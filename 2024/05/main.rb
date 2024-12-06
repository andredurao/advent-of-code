# Part 1

class Part1
  attr_accessor :lines, :pairs, :sequences

  def initialize
    @lines = File.readlines(ARGV[0]).map(&:chomp)
    @pairs = []
    @sequences = []

    i = 0
    while i < lines.size - 1 do
      if lines[i].size == 0
        i += 1
        break
      end
      @pairs << lines[i].split('|').map(&:to_i)
      i += 1
    end

    while i < lines.size - 1 do
      @sequences << lines[i].split(',').map(&:to_i)
      i += 1
    end
  end

  def solve
    a_b_map = {}

    @pairs.each do |a, b|
      a_b_map[a] ||= Set.new ; a_b_map[b] ||= Set.new
      a_b_map[a] += [b]
    end

    total = 0

    @sequences.each do |sequence|
      valid = true
      0.upto(sequence.size - 2) do |i|
        if !a_b_map[sequence[i]].include?(sequence[i+1])
          valid = false
          break
        end
      end
      total += sequence[sequence.size/2] if valid
    end

    total
  end
end

raise "usage: main.rb FILENAME" if ARGV.size == 0

part1 = Part1.new
puts part1.solve
