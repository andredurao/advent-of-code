def log(x)
  p(x) if ENV['DEBUG']
end

def get_lights(pos, forest, map)
  height = forest.size
  width = forest[0].size
  i, j = pos
  total = 0
  # ray cast from left to right
  ray = 0
  while ray < j
    break if forest[i][ray] >= forest[i][j]
    ray += 1
  end
  map[i][j] += 1 if ray == j
  # ray cast from right to left
  ray = width - 1
  while ray > j
    break if forest[i][ray] >= forest[i][j]
    ray -= 1
  end
  map[i][j] += 1 if ray == j
  # ray cast from top to bottom
  ray = 0
  while ray < i
    break if forest[ray][j] >= forest[i][j]
    ray += 1
  end
  map[i][j] += 1 if ray == i
  # ray cast from bottom to top
  ray = height - 1
  while ray > i
    break if forest[ray][j] >= forest[i][j]
    ray -= 1
  end
  map[i][j] += 1 if ray == i
end

forest = []
File.readlines(ARGV[0]).each do |line|
  forest << line.chomp.chars
end

# init lightning map
map = forest.map{|row| Array.new(row.size, 0)}

forest.each_with_index do |row, i|
  row.each_with_index do |tree, j|
    get_lights([i,j], forest, map)
  end
end
map.each{|row| log(row)}

result = 0
map.each do |row|
  row.each do |item|
    result += 1 if item > 0
  end
end
p result

