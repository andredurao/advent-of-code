raise "usage: main.rb FILENAME" if ARGV.size == 0

def rotate(pos, move)
  dir, qty = move[0], move[1..].to_i

  # R: +, L: -
  pos += qty if dir == ?R
  pos -= qty if dir == ?L
  pos % 100
end

def part1(moves)
  res = 0
  pos = 50

  moves.each do |move|
    pos= rotate(pos, move)
    res += 1 if pos == 0
  end

  puts "part1: #{res}"
end

def part2(moves)
  res = 0
  pos = 50

  moves.each do |move|
    dir, qty = move[0], move[1..].to_i

    if dir == ?R
      pos += qty

      res += pos / 100
    end

    if dir == ?L
      pos -= qty

      res += pos / -100
      # increase 1 if initial pos was not zero
      res += 1 if (pos + qty) > 0
    end

    pos %= 100
  end

  puts "part2: #{res}"
end

moves = File.readlines(ARGV[0]).map(&:chomp)

part1(moves)
part2(moves)
