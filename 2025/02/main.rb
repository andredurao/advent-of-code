raise "usage: main.rb FILENAME" if ARGV.size == 0


def get_ranges
  lines = File.readlines(ARGV[0]).map(&:chomp)

  lines[0].split(',').map do |range|
    v1, v2 = range.split(?-).map(&:to_i)
  end
end

def half(n)
  str = n.to_s
  str[0..(str.size/2-1)].to_i
end

# repeat the number to create a fake id
def fake_id(n)
  "#{n}#{n}".to_i
end

def part1(ranges)
  res = 0

  ranges.each do |range|
    range[0].upto(range[1]) do |n|
      if n == fake_id(half(n))
        res += n
      end
    end
  end

  puts "part 1: #{res}"
end

def part2(ranges)
  res = 0

  ranges.each do |range|
    range[0].upto(range[1]) do |n|
      str = n.to_s
      next if str.size < 2
      block = str[0..(str.size/2-1)]
      while(block.size > 0) do
        mult = str.size / block.size

        if str.size % mult != 0
          block = block[..-2]
          next
        end

        repeated_block = block * mult
        if repeated_block == str
          res += n
          break
        end

        block = block[..-2]
      end

    end
  end

  puts "part 2: #{res}"
end

ranges = get_ranges

part1(ranges)
part2(ranges)
