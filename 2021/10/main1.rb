class Parser
  SYNTAX = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }
  STARTER_TOKEN = SYNTAX.keys
  POINTS = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }

  def initialize
  end

  def parse(line)
    stack = []
    line.chars.each do |char|
      if STARTER_TOKEN.include?(char)
        stack.push(char)
      else
        raise "empty stack" if stack.empty?
        expected = SYNTAX[stack.pop]
        if expected != char
          puts "Expected #{expected}, but found #{char} instead"
          return POINTS[char]
        end
      end
    end
    0
  end
end

parser = Parser.new
#lines = File.readlines('example', chomp: true)
lines = File.readlines('input', chomp: true)
#parser.parse('{([(<{}[<>[]}>{[]{[(<()>')

total = 0
lines.each do |line|
  #p line
  result = parser.parse(line)
  total += result
end
p total
