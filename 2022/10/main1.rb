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

def execute(instr, registers)
  if addx?(instr)
    registers[:x] += instr.split[1].to_i
  end
end

INSTR_SET = { 'nopp' => 1, 'addx' => 2 }
lines = File.readlines(ARGV[0], chomp: true)
cycles = [20, 60, 100, 140, 180, 220]

registers = { x: 1 }
pc = 1
result = 0
stack = []
while lines.any? || stack.any?
  instr = if stack.any?
    execute(stack.first, registers)
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
  if cycles.include?(pc)
    result += registers[:x] * pc
    log("#{pc} #{instr}")
  end
end
p registers
p result
