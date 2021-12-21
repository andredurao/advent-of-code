class Stream
  attr_accessor :payload, :cursor, :result
  def initialize(payload)
    @result = 0
    @cursor = 0
    @payload = payload
  end

  def read(n)
    str = @payload[@cursor...(@cursor+n)]
    @payload[@cursor,@cursor+n] = ''
    str
  end

  def eof?
    @payload.empty?
  end

  def inspect
    puts payload
    puts " " * @cursor + "|"
  end
end

class Puzzle
  OPS = { 0 => '+', 1 => '*', 2 => 'min', 3 => 'max', 4 => 'lit', 5 => 'gt', 6 => 'lt', 7 => 'eq' }
  attr_accessor :line, :input, :cursor

  def initialize(line)
    @cursor = 0
    @line = line
    build_bits(line)
    @input = Stream.new(@payload)
  end

  def solve
    unpack(@input)
    p @input.result
  end

  def unpack(stream, sp="")
    version = read_version(stream)
    op = read_op(stream)

    if op == 'lit'
      value = read_literal(stream)
      # puts value
      stream.result = value
      return stream
    else
      values = []
      length_type = btoi(stream.read(1))
      length = length_type == 0 ? 15 : 11
      n = btoi(stream.read(length))
      if length_type == 0
        new_stream = Stream.new(stream.read(n))
        while !new_stream.eof?
          values << unpack(new_stream, "\t").result
        end
      else
        n.times do
          values << unpack(stream, "\t").result
        end
      end
      final = 0
      case op
      when '+'
        final = values.sum
      when '*'
        final = values.reduce(1) {|memo,val| memo *= val ; memo}
      when 'min'
        final = values.min
      when 'max'
        final = values.max
      when 'lt'
        x, y = values
        final = x < y ? 1 : 0
      when 'gt'
        x, y = values
        final = x > y ? 1 : 0
      when 'eq'
        x, y = values
        final = x == y ? 1 : 0
      end
      # puts "#{sp} #{type} #{values}"
      # puts "#{sp} [#{final}]"
      stream.result = final
      return stream
    end
  end

  def read_op(stream = @input)
    OPS[btoi(stream.read(3))]
  end

  def read_version(stream = @input)
    btoi(stream.read(3))
  end

  def read_literal(stream = @input)
    str = ""
    while true
      word = stream.read(5)
      str += word[1..-1]
      return btoi(str) if word[0] == '0'
    end
  end

  def btoi(str)
    (str || '').to_i(2)
  end

  # pack nibble into a string
  def build_bits(lines)
    @payload = ""
    lines[0].chars.each do |hex|
      @payload << sprintf('%04b', hex.to_i(16))
    end
  end

  def debug
    p @payload
  end
end

lines = File.readlines(ARGV[0], chomp: true)
puzzle = Puzzle.new(lines)
#puzzle.debug
puzzle.solve
