require 'json'

def leaf(str, cursor)
  str = str[cursor..]
  index = str.index(']')
  str[0..index]
end

def get_left_number(str)
  index = str.rindex(/,\d+|\[\d+/)
  return [nil, nil] if !index
  index += 1 # jump "," or "["
  number = /\d+/.match(str[index..])[0].to_i
  [index, number]
end

def get_right_number(str)
  index = str.index(/\d+/)
  return [nil, nil] if !index
  number = /\d+/.match(str)[0].to_i
  [index, number]
end

def has_left_number?(str)
  pos, _ = get_left_number(str)
  !!pos
end

def has_right_number?(str)
  pos, _ = get_right_number(str)
  !!pos
end

def height(str)
  max = 0
  index = 0
  height = 0
  str.chars.each_with_index do |c, i|
    case c
    when '['
      height += 1
      if height > max
        max = height
        index = i
      end
    when ']'
      # ============
      if height > 4
        return [max, index]
      end
      # ============
      height -= 1
    end
  end
  [max, index]
end

def xplode(str)
  result = ""
  while true
    height, cursor = height(str)
    if height > 4
      block = leaf(str, cursor)
      if @debug
        puts str
        puts "#{" " * cursor}X"
      end
      array = JSON.parse(block)
      shift = (cursor + block.length)

      if has_left_number?(str[..cursor]) && has_right_number?(str[shift..])
        # p 'BOTH'
        lpos, l = get_left_number(str[..cursor])
        rpos, r = get_right_number(str[shift..])
        result << str[..(lpos - 1)] + (l + array[0]).to_s
        result << str[(lpos + l.to_s.length)..cursor-1] + '0'
        result << str[shift..(shift+rpos-1)]
        result << (r + array[1]).to_s
        result << str[shift+rpos+r.to_s.length..]
      elsif has_left_number?(str[..cursor])
        # p 'LEFT'
        lpos, l = get_left_number(str[..cursor])
        result << str[..(lpos - 1)] + (l + array[0]).to_s
        result << str[(lpos + l.to_s.length)..cursor-1] + '0' + str[shift..]
      elsif has_right_number?(str[shift..])
        # p 'RIGHT'
        rpos, r = get_right_number(str[shift..])
        rpos += shift
        result << str[..cursor-1] + '0' + str[shift..rpos-1]
        result << (r + array[1]).to_s + str[rpos+r.to_s.length..]
      end

      return result
    else
      return str
    end
  end
  str
end

def explode(str)
  while true
    result = xplode(str)
    return result if result == str
    str = result
  end
end

def split(str)
  cursor = 0
  count = 0
  result = ""
  while true
    index = str.index(/\d\d+/)
    return str if !index
    if @debug
      puts str
      puts "#{" " * index}S"
    end
    m = /\d\d+/.match(str[index..])
    n = m[0].to_i
    l = n.fdiv(2).floor
    r = n.fdiv(2).ceil
    result << str[..index-1] + "[#{l},#{r}]" + str[(index+n.to_s.length)..]
    # puts "| " * 50
    return result
    str = result
    result = ""
  end
  str
end

def process(str)
  original = str.clone
  result = ""
  while true
    result = explode(str)
    result = split(result)
    break if str == result
    str = result
    result = ""
  end
  str
end

def sum(items)
  result = items[0]
  1.upto(items.size-1) do |i|
    item = process(items[i].to_s.gsub(' ', ''))
    result = [result] << items[i]
    str = result.to_s.gsub(' ', '')
    processed = process(str)
    result = JSON::parse(processed)
  end
  result.to_s.gsub(' ', '')
end

def check_magnitude(str)
  start = -1
  str.chars.each_with_index do |c, i|
    case c
    when '['
      start = i
    when ']'
      block = str[start..i]
      l, r = JSON.parse(block)
      total = 3*l + 2*r
      if start == 0 && i == (str.length - 1)
        return ["", total]
      else
        result = str[..start-1] + total.to_s + str[i+1..]
        return [result, -1]
      end
    end
  end
end

def magnitude(str)
  while true
    str, total = check_magnitude(str)
    return total if str.empty?
  end
end

@debug = false

lines = File.readlines(ARGV[0], chomp: true)
items = lines.map{|line| JSON::parse(line)}
res = sum(items)
p magnitude(res)
