def move(line, pos)
  moves = {
    "forward" => ->(pos, value) do
      pos[0] += value
      pos[1] += pos[2] * value
      pos
    end,
    "down"    => ->(pos, value) do
      pos[2] += value
      pos
    end,
    "up"      => ->(pos, value) do
      pos[2] -= value
      pos
    end,
  }
  values = line.split
  command = values[0]
  value = values[1].to_i
  moves[command].(pos, value)
end

lines = File.readlines('input', chomp: true)
pos = [0,0,0]
lines.each do |line|
  pos = move(line, pos)
end
p pos[0] * pos[1]
