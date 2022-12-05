def log(x)
  p(x) if ENV['DEBUG']
end

commands = []
stack_lines = []
# pre-process
File.readlines(ARGV[0]).each do |line|
  line.chomp!
  next if line.empty?
  if line.start_with?('move')
    commands << line
  else
    stack_lines << line
  end
end

stack_lines.each{|l| puts(l)}
stacks_indexes = {}
stack_lines.last.chars.each_with_index do |num, index|
  stacks_indexes[num] = index if /\d/ === num
end

stacks = {}
stack_lines[..-2].each do |line|
  chars = line.chars
  stacks_indexes.each do |num, index|
    if chars[index] && /\w/ === chars[index]
      stacks[num] ||= []
      stacks[num] << chars[index]
    end
  end
end

log(stacks)
command = commands[0]
commands.each do |command|
  log('=======================')
  match = /move (\d+) from (\d+) to (\d+)/.match(command)
  qty = match[1].to_i
  from, to = match[2..3]
  log([qty, from, to])
  temp_from = stacks[from].dup
  stacks[from] = stacks[from][qty..] # remove
  stacks[to] = temp_from[0...qty].reverse + stacks[to] # append at the beggining
  log(stacks)
end

result = []
stacks.keys.sort.each do |key|
  result << stacks[key].first
end

p result.join
