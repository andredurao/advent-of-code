def move(line, pos)
  moves = {
    "forward" => ->(pos, value){ pos[0] += value ; pos },
    "down"    => ->(pos, value){ pos[1] += value ; pos },
    "up"      => ->(pos, value){ pos[1] -= value ; pos },
  }
  values = line.split
  command = values[0]
  value = values[1].to_i
  moves[command].(pos, value)
end

lines = File.readlines('input', chomp: true)
pos = [0,0]
lines.each do |line|
  pos = move(line, pos)
end
p pos[0] * pos[1]
