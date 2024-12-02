raise "usage: main.rb FILENAME" if ARGV.size == 0

class LevelValidator
  class << self
    def call(line:)
      self.new(line:).valid?
    end
  end

  attr_accessor :line
  def initialize(line:)
    @line = line.split(' ').map(&:to_i)
  end

  def valid?
    ordered? && valid_distance?
  end

  def ordered?
    @line.sort == @line || @line.sort.reverse == @line
  end

  def valid_distance?
    1.upto(@line.size - 1) do |i|
      dist = (line[i] - line[i-1]).abs
      return false if dist < 1 || dist > 3
    end
    true
  end
end

total = 0
File.readlines(ARGV[0]).map(&:chomp).each do |line|
  total += 1 if LevelValidator.(line:)
end

puts "part1: #{total}"
