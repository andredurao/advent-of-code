#entries = File.readlines('example', chomp: true)
entries = File.readlines('input', chomp: true)

digits = {0 => 6, 1 => 2, 2 => 5, 3 => 5, 4 => 4, 5 => 5, 6 => 6, 7 => 3, 8 => 7, 9 => 6}

values = digits.keys.inject({}) do |memo, key|
  value = digits[key]
  memo[value] ||= []
  memo[value] << key
  memo
end

unique_values = [2, 3, 4, 7]
total = 0
entries.each do |entry|
  signal, output = entry.split('|').map(&:split)
  output.each do |item|
    if unique_values.include?(item.length)
      total += 1 
    end
  end
end

p total
