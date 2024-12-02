raise "usage: main.rb FILENAME" if ARGV.size == 0

class LevelValidator1
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
    line.sort == line || line.sort.reverse == line
  end

  def valid_distance?
    1.upto(line.size - 1) do |i|
      dist = (line[i] - line[i-1]).abs
      return false if dist < 1 || dist > 3
    end
    true
  end
end

total = 0
File.readlines(ARGV[0]).map(&:chomp).each do |line|
  total += 1 if LevelValidator1.(line:)
end

puts "part1: #{total}"

# Part 2

class LevelValidator2
  class << self
    def call(nums:)
      self.new(nums:).valid?
    end
  end

  attr_accessor :nums
  def initialize(nums:)
    @nums = nums
  end

  def valid?
    ordered? && valid_distance?
  end

  def ordered?
    nums.sort == nums || nums.sort.reverse == nums
  end

  def valid_distance?
    1.upto(nums.size - 1) do |i|
      dist = (nums[i] - nums[i-1]).abs
      return false if dist < 1 || dist > 3
    end
    true
  end
end

total = 0
File.readlines(ARGV[0]).map(&:chomp).each do |line|
  nums = line.split(' ').map(&:to_i)

  if LevelValidator2.(nums:)
    total += 1
  else
    # brute force removing single itens of array
    0.upto(nums.size - 1) do |i|
      partial = nums.dup
      partial.delete_at(i)
      if LevelValidator2.(nums: partial)
        total += 1
        break
      end
    end
  end
end

puts "part2: #{total}"
