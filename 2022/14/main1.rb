def limit_values(paths)
  min_x = -1 ; min_y = -1 ; max_x = -1 ; max_y = -1
  paths.each do |positions|
    positions.each do |x,y|
      min_x = min_x == -1 ? x : [min_x, x].min
      min_y = min_y == -1 ? y : [min_y, y].min
      max_x = max_x == -1 ? x : [max_x, x].max
      max_y = max_y == -1 ? y : [max_y, y].max
    end
  end
  [min_x, min_y, max_x, max_y]
end

def print_map(map)
  map.each{|line| puts(line.join)}
end

def draw(map, paths)
  paths.each do |path|
    prev = nil
    path.each do |x,y|
      if prev
        p "#{prev}->#{[x,y]}"
        px, py = prev
        [px,x].min.upto([px,x].max) do |j|
          [py,y].min.upto([py,y].max) do |i|
            p [i,j]
            map[i][j] = '#'
          end
        end
      end
      prev = [x,y]
    end
  end
end

paths = []
File.readlines(ARGV[0], chomp: true).each do |line|
  items = line.split(' -> ').map{|pos| pos.split(',').map(&:to_i)}
  paths << items
end

min_x, min_y, max_x, max_y = limit_values(paths)

# remap slide map to leftmost position
new_paths = paths.map do |positions|
  positions.map do |x,y|
    [x - min_x + 2, y]
  end
end

p new_paths

min_x, min_y, max_x, max_y = limit_values(new_paths)

map = Array.new(max_y + 1, [' '] * (max_x + 1))

draw(map, new_paths)

print_map(map)
