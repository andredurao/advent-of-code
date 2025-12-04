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

def part1(banks)
  res = 0

  banks.each do |bank|
    print ?.
    res += max_pair_sequential(bank)
  end
  puts

  puts "part 1: #{res}"
end

banks = get_banks

part1(banks)
