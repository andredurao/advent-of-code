valves = {}

TIME = 30

File.readlines(ARGV[0], chomp: true).each do |line|
  m = /Valve (\w+) has flow rate=(\d+); tunnel\w? lead\w? to valve\w? (.*)/.match(line)
  p m
  id = m[1]
  valves[id] = {
    flow: m[2].to_i,
    open: false,
    valves: m[3].split(', ')
  }
end

p valves
