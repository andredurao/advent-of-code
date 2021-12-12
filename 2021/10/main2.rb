class Parser
  SYNTAX = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }
  STARTER_TOKEN = SYNTAX.keys
  POINTS = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }

  def initialize
  end

  def parse(line)
    stack = []
    score = []
    line.chars.each do |char|
      if STARTER_TOKEN.include?(char)
        stack.push(char)
      else
        raise "empty stack" if stack.empty?
        expected = SYNTAX[stack.pop]
        if expected != char
          return 0
        end
      end
    end
    if stack.size > 0
      complete = stack.reverse.map do |char|
        SYNTAX[char]
      end
      total = 0
      complete.each do |char|
        total *= 5
        total += POINTS[char]
      end
      return total
    end
    0
  end
end

parser = Parser.new
#lines = File.readlines('example', chomp: true)
lines = File.readlines('input', chomp: true)
# p parser.parse('<{([{{}}[<[[[<>{}]]]>[]]')

results = []
lines.each do |line|
  result = parser.parse(line)
  if result > 0
    results << result
  end
end
results.sort!
middle = results.size / 2
p results[middle]
