def log(x)
  p(x) if ENV['DEBUG']
end

def command?(line)
  line.start_with?('$')
end

def file?(line)
  /\d+\s.*/ === line
end

def dir?(line)
  /dir\s.*/ === line
end

def current_dir(disk, dir_stack)
  ref = disk
  stack = dir_stack.dup
  while stack.any?
    dir = stack.shift
    ref[dir] ||= { files: {}, size: 0 }
    ref = ref[dir]
  end
  ref
end

# update sizes for all directories recursively
def dfs_update_sizes(dir)
  dir.each do |k,v|
    if ![:files, :size].include?(k) # check if the key is a dir
      dir[:size] += dfs_update_sizes(dir[k])
    end
  end
  dir[:size]
end


# search
def dfs_search_for(dir, result=[])
  result << dir[:size]
  dir.each do |k,v|
    if ![:files, :size].include?(k) # check if the key is a dir
      dfs_search_for(dir[k], result)
    end
  end
  result
end

disk = { files: {}, size: 0 }
dir_stack = []
File.readlines(ARGV[0]).each do |line|
  line.chomp!
  if command?(line)
    args = line.split
    if args[1] == 'cd'
      log(line)
      dir_name = args[2]
      if dir_name == '..'
        dir_stack.pop
      else
        dir_stack << args[2]
      end
    end
  elsif file?(line)
    dir = current_dir(disk, dir_stack)
    filesize, filename = line.split
    dir[:files][filename] = filesize.to_i
    dir[:size] += filesize.to_i
  else
  end
end

# sum up children dir sizes into their parents
dfs_update_sizes(disk['/'])

# collect all dir sizes
dir_sizes = dfs_search_for(disk['/'])

total_size = 70000000
needed = 30000000
free = total_size - disk['/'][:size] 
smallest_dir_size = Float::INFINITY
dir_sizes.each do |dir_size|
  if free + dir_size >= needed
    smallest_dir_size = [smallest_dir_size, dir_size].min
  end
end

p smallest_dir_size
