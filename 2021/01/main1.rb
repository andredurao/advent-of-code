measures = File.readlines('input', chomp: true)
total = 0
previous = -1
measures.each do |measure|
  value = measure.to_i
  total += 1 if previous != -1 && value > previous
  previous = value
end
p total
