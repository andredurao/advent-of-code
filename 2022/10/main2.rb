def log(x)
  p(x) if ENV['DEBUG']
end

def inst_name(line)
  line.split.first
end

def noop?(line)
  inst_name(line) == 'noop'
end

def addx?(line)
  inst_name(line) == 'addx'
end

INSTR_SET = { 'nopp' => 1, 'addx' => 2 }
lines = File.readlines(ARGV[0], chomp: true)
cycles = [20, 60, 100, 140, 180, 220]

x = 1
pc = 1
stack = []
screen = []
6.times{screen << (' ' * 40)}
while lines.any? || stack.any?
  log "cycle #{pc} x=#{x}"
  v = (pc - 1) / 40
  h = (pc - 1) % 40
  if [x-1, x, x+1].include?(h)
    screen[v][h] = '#'
  end

  instr = if stack.any?
    if addx?(instr)
      x += instr.split[1].to_i
    end
    stack.shift
  else
    if noop?(lines.first)
      lines.shift
    else
      stack << lines.shift
      stack.first
    end
  end

  pc += 1
end

screen.each{|row| puts row}
