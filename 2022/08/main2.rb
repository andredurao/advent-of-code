def log(x)
  p(x) if ENV['DEBUG']
end

def look_right(pos, forest, height, width)
  i, j = pos
  view = 0
  ray = j + 1
  while ray < width
    log [i,j,forest[i][ray],forest[i][j]]
    view += 1
    break if forest[i][ray] >= forest[i][j]
    ray += 1
  end
  view
end

def look_left(pos, forest, height, width)
  i, j = pos
  view = 0
  ray = j - 1
  while ray >= 0
    log [i,j,forest[i][ray],forest[i][j]]
    view += 1
    break if forest[i][ray] >= forest[i][j]
    ray -= 1
  end
  view
end

def look_down(pos, forest, height, width)
  i, j = pos
  view = 0
  ray = i + 1
  while ray < height
    log [i,j,forest[i][ray],forest[i][j]]
    view += 1
    break if forest[ray][j] >= forest[i][j]
    ray += 1
  end
  view
end

def look_up(pos, forest, height, width)
  i, j = pos
  view = 0
  ray = i - 1
  while ray >= 0
    log [i,j,forest[i][ray],forest[i][j]]
    view += 1
    break if forest[ray][j] >= forest[i][j]
    ray -= 1
  end
  view
end

def get_lights(pos, forest, height, width)
  [
    look_up(pos, forest, height, width),
    look_left(pos, forest, height, width),
    look_down(pos, forest, height, width),
    look_right(pos, forest, height, width),
  ]
end

forest = []
File.readlines(ARGV[0]).each do |line|
  forest << line.chomp.chars
end

height = forest.size
width = forest[0].size
max = 0
forest.each_with_index do |row, i|
  row.each_with_index do |tree, j|
    lights = get_lights([i,j], forest, height, width)
    log([i,j,lights])
    max = [lights.reduce(&:*), max].max
  end
end

p max
