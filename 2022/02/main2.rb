VALUES = { 'A' => 1,   'B' => 2,   'C' => 3   }
XREF   = { 'X' => 'A', 'Y' => 'B', 'Z' => 'C' }
ACTIONS = {
  'X' => { 'A' => 'Z', 'B' => 'X', 'C' => 'Y' },
  'Y' => { 'A' => 'X', 'B' => 'Y', 'C' => 'Z' },
  'Z' => { 'A' => 'Y', 'B' => 'Z', 'C' => 'X' }
}
ACTION_VALUES = { 'X' => 0, 'Y' => 3, 'Z' => 6 }
total = 0
File.readlines(ARGV[0]).each do |line|
  v1, v2 = line.chomp.split(' ')
  total += ACTION_VALUES[v2]
  target = ACTIONS[v2][v1]
  total += VALUES[XREF[target]]
end
p total
