require 'set'
DIRS = { 'R' => [0,1], 'D' => [-1,0], 'L' => [0,-1], 'U' => [1,0] }.freeze

def log(x)
  p(x) if ENV['DEBUG']
end

def debug(head, tail)
  4.downto(0) do |i|
    0.upto(5) do |j|
      if [i,j] == head && head == tail
        print 'H'
      elsif [i,j] == head
        print 'H'
      elsif [i,j] == tail
        print 'T'
      else
        print '.'
      end
    end
    print "\n"
  end
  puts
end

def distances(head, tail)
  return 0 if head == tail
  dy = (head[0] - tail[0]).abs
  dx = (head[1] - tail[1]).abs
  [dy, dx].max
end

def tail_pos(head, tail, dir)
  # binding.irb if dir == 'U'
  d = distances(head, tail)
  return tail if d < 2
  rev_dir = DIRS[dir].map{|val| val * -1}
  [
    head[0] + rev_dir[0],
    head[1] + rev_dir[1]
  ]
end

def move(head, tail, dir)
  i, j = DIRS[dir]
  new_head = [head[0] + i, head[1] + j]
  new_tail = tail_pos(new_head, tail, dir)
  [new_head, new_tail]
end

moves = File.readlines(ARGV[0]).map(&:chomp)

tail_set = Set.new

head = [0,0]
tail = [0,0]
moves.each do |move|
  log move
  dir, count = move.split
  count.to_i.times do
    result = move(head, tail, dir)
    # p result
    head, tail = result
    # p(head, tail)
    # debug(head, tail)
    tail_set.add(tail)
  end
  log '----------------------'
end

p tail_set.size
# head, tail = move(head, tail, 'R')
# p [head, tail]
# head, tail = move(head, tail, 'R')
# p [head, tail]
