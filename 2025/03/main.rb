raise "usage: main.rb FILENAME" if ARGV.size == 0

def get_banks
  lines = File.readlines(ARGV[0]).map(&:chomp)
  lines.map {|line| line.chars.map(&:to_i)}
end

def max_pair_sequential(bank)
  max = 0
  size = bank.size
  qty = size - 1
  i = 0
  0.upto(qty) do |i|
    qty.downto(1) do |j|
      break if i == j
      value = bank[i]*10 + bank[j]
      max = [max, value].max
    end
  end
  max
end

# Lookup for the largest digit from left to right that's most on the left of the window
# starting at start_at
# ending at size - values_remaining
# returns a pair [digit, index]
def get_largest(bank, start_at, values_remaining)
  max = [-1, -1]
  final_index = bank.size - values_remaining

  start_at.upto(final_index) do |i|
    max = [bank[i], i] if bank[i] > max[0]
  end
  max
end

# check the largest n digits (n > 0 | n = size) from left to right
# the window used is defined on get_largest function
# shift left digits on each iteration
def max_pair(bank, size)
  stack = []
  res = 0
  digits = 0
  start_at = 0
  while digits < size
    digit, pos = get_largest(bank, start_at, size - digits)
    res = res * 10 + digit # TODO only if size > 1
    start_at = pos+1
    digits += 1
  end
  res
end

def part1(banks)
  res = 0

  banks.each do |bank|
    print ?.
    res += max_pair_sequential(bank)
  end
  puts

  puts "part 1: #{res}"
end

def part2(banks)
  res = 0

  banks.each do |bank|
    print ?.
    res += max_pair(bank, 12)
  end
  puts

  puts "part 2: #{res}"
end

banks = get_banks

part1(banks)
part2(banks)
