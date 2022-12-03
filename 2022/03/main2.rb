chars = Array('a'..'z') + Array('A'..'Z')
priorities = {}
chars.each_with_index{|c,i| priorities[c] = i+1}

def shared(stack)
  (stack[0].chars & stack[1].chars & stack[2].chars)[0]
end

stack = []
total = 0

File.readlines(ARGV[0]).each do |line|
  stack << line.chomp
  if stack.size == 3
    char = shared(stack)
    total += priorities[char]
    stack = []
  end
end

p total
