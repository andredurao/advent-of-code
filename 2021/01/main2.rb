def set(measures, index)
  return [] if index + 3 > measures.length
  measures[index..index+2]
end

measures = File.readlines('input', chomp: true).map(&:to_i)

total = 0
previous = -1
0.upto(measures.length - 3) do |i|
  current_set = set(measures, i)
  value = current_set.inject(:+)
  total += 1 if previous != -1 && value > previous
  previous = value
end
p total
