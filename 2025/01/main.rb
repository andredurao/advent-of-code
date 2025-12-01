raise "usage: main.rb FILENAME" if ARGV.size == 0

moves = File.readlines(ARGV[0]).map(&:chomp)

res = 0
pos = 50

def rotate(pos, move)
  dir, qty = move[0], move[1..].to_i
  # R: +, L: -
  pos += qty if dir == ?R
  pos -= qty if dir == ?L

  pos % 100
end

moves.each do |move|
  pos, crossed_zero = rotate(pos, move)
  # p move
  res += 1 if pos == 0
end

p res
