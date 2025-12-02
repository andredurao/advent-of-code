raise "usage: main.rb FILENAME" if ARGV.size == 0

def rotate(pos, move)
  dir, qty = move[0], move[1..].to_i
  # R: +, L: -
  pos += qty if dir == ?R
  pos -= qty if dir == ?L

  crossed_zero = pos > 99 || pos <= 0

  [pos % 100, crossed_zero]
end

def part1(moves)
  res = 0
  pos = 50

  moves.each do |move|
    pos, crossed_zero = rotate(pos, move)
    res += 1 if pos == 0
  end

  puts "part1: #{res}"
end

moves = File.readlines(ARGV[0]).map(&:chomp)

part1(moves)
