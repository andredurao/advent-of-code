DIGITS = {
  0 => %w[a b c e f g],
  1 => %w[c f],
  2 => %w[a c d e g],
  3 => %w[a c d f g],
  4 => %w[b c d f],
  5 => %w[a b d f g],
  6 => %w[a b d e f g],
  7 => %w[a c f],
  8 => %w[a b c d e f g],
  9 => %w[a b c d f g],
}
DECODER = DIGITS.invert
UNIQUE_DIGITS = { 1 => 2, 7 => 3, 4 => 4, 8 => 7 }

def parse(line)
  line.split('|').map(&:split)
end

def remap(signal)
  map = {}
  cypher = {}
  digits_by_size = signal.reduce({}) do |memo, digit|
    memo[digit.size] ||= []
    memo[digit.size] << digit.chars
    memo
  end
  # find values with unique digits
  UNIQUE_DIGITS.each do |value, length|
    map[value] = digits_by_size[length][0]
  end
  #p digits_by_size
  # seg a = '7' - '1'
  cypher['a'] = (map[7] - map[1])[0]
  # segs c,f -> there are 3 digits with 6 segs: 0,6,9. Only one is missing one of the segs in digit 1 => the missing seg is c
  d0 = nil
  remainder0 = -1
  remainder9 = -1
  digits_by_size[6].each do |digit|
    diff = digit - map[1]
    if diff.size == 5 # digit 6
      cypher['f'] = (digit - diff)[0]
      cypher['c'] = (map[1] - [cypher['f']])[0]
    else
      diff = digit - map[4]
      if diff.size == 3
        remainder0 = diff 
        d0 = digit
      end
      remainder9 = diff if diff.size == 2
    end
  end
  # e is the difference between 9, 4, 0 => 
  # 9 - 4 => [a g] ; 0 - 4 => [a e g]
  cypher['e'] = (remainder0 - remainder9)[0]
  cypher['g'] = (remainder0 - [cypher['a'], cypher['e'], cypher['g']])[0]
  cypher['b'] = (d0 - [cypher['a'], cypher['c'], cypher['e'], cypher['f'], cypher['g']])[0]
  cypher['d'] = (map[8] - [cypher['a'], cypher['b'], cypher['c'], cypher['e'], cypher['f'], cypher['g']])[0]

  cypher.sort.to_h
end

def decode(cypher, output)
  result = ''
  output.each do |encoded_value|
    segs = encoded_value.chars.sort
    new_value = []
    segs.each do |seg|
      new_value << cypher[seg]
    end
    result << DECODER[new_value.sort].to_s
  end
  result.to_i
end

#entries = File.readlines('example', chomp: true)
entries = File.readlines('input', chomp: true)

total = 0
entries.each do |entry|
  signal, output = parse(entry)
  cypher = remap(signal)
  total += decode(cypher.invert, output)
end
p total
