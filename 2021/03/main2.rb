MAX = 12
def get_freqs(lines, index)
  freq = { '0' => 0, '1' => 0 }
  lines.each do |line|
    char = line.chars[index]
    freq[char] += 1
  end
  freq
end

def get_o2(lines)
  result = ''
  index = 0
  while true
    new_lines = []
    freqs = get_freqs(lines, index)
    # choose largest or 1
    if freqs['1'] > freqs['0']
      comp = '1'
    elsif freqs['1'] < freqs['0']
      comp = '0'
    else
      comp = '1'
    end
    # filtering
    lines.each do |line|
      new_lines << line if line.chars[index] == comp
    end
    lines = new_lines
    return lines.first if lines.size == 1
    index += 1 if index < MAX
  end
end

def get_co2(lines)
  result = ''
  index = 0
  while true
    new_lines = []
    freqs = get_freqs(lines, index)
    # choose largest or 1
    if freqs['1'] < freqs['0']
      comp = '1'
    elsif freqs['1'] > freqs['0']
      comp = '0'
    else
      comp = '0'
    end
    # filtering
    lines.each do |line|
      new_lines << line if line.chars[index] == comp
    end
    lines = new_lines
    return lines.first if lines.size == 1
    index += 1 if index < MAX
  end
end

lines = File.readlines('input', chomp: true)
# words are 12bits long

o2 = get_o2(lines).to_i(2)
p o2

co2 = get_co2(lines).to_i(2)
p co2

p o2 * co2
