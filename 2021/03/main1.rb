def most_used_bit(lines, index)
end

lines = File.readlines('input', chomp: true)
# words are 12bits long
freq = {}
lines.each do |line|
  line.chars.each_with_index do |char, i|
    freq[i] ||= { '0' => 0, '1' => 0 }
    freq[i][char] += 1
  end
end

gamma_str = ''
epsilon_str = ''

freq.each do |index, values|
  if values['1'] > values['0']
    gamma_str[index] = '1'
    epsilon_str[index] = '0'
  else
    gamma_str[index] = '0'
    epsilon_str[index] = '1'
  end
end

gamma = gamma_str.to_i(2)
epsilon = epsilon_str.to_i(2)

p gamma * epsilon
