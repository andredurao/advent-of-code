require 'set'
DIRS = { 'R' => [0,1], 'D' => [-1,0], 'L' => [0,-1], 'U' => [1,0] }.freeze

def log(x)
  p(x) if ENV['DEBUG']
end

def debug(head, tails)
  tails_map = {}
  tails.each_with_index{|tail, index| tails_map[tail] = index + 1 if !tails_map[tail]}
  4.downto(0) do |i|
    0.upto(5) do |j|
      if [i,j] == head
        print 'H'
      elsif [i,j] == head
        print 'H'
      elsif tails_map[[i,j]]
        print tails_map[[i,j]]
      else
        print '.'
      end
    end
    print "\n"
  end
  puts
end

def distances(from, to)
  return [0,0] if from == to
  dy = from[0] - to[0]
  dx = from[1] - to[1]
  [dy, dx]
end

def move(head, dir)
  i, j = DIRS[dir]
  [head[0] + i, head[1] + j]
end

# maybe clamp could be used
def value_in_range(value, min, max)
  return value if (min..max).include?(value)
  value < min ? min : max
end

def tail_pos(from, to)
  delta = distances(from, to)
  return to if delta.map(&:abs).max < 2

  result = to.dup
  result[0] += value_in_range(delta[0], -1, 1)
  result[1] += value_in_range(delta[1], -1, 1)
  result
end

def move_tails(head, tails, dir)
  result = []
  from = head
  tails.each do |tail|
    new_pos = tail_pos(from, tail)
    from = new_pos
    result << new_pos
  end
  result
end

moves = File.readlines(ARGV[0]).map(&:chomp)

tail_set = Set.new

head = [0,0]
tails = Array.new(9, [0,0])
moves.each do |move|
  log move
  dir, count = move.split
  count.to_i.times do
    head = move(head, dir)
    tails = move_tails(head, tails, dir)
    tail_set.add(tails.last)
    log head
    log tails
  end
  log '----------------------'
end

p tail_set.size
