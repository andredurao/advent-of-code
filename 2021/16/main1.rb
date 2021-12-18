class Stream
  attr_accessor :payload, :cursor
  def initialize(payload)
    @cursor = 0
    @payload = payload
  end

  def read(n)
    str = @payload[@cursor...(@cursor+n)]
    @cursor += n
    str
  end


  def eof?
    @cursor >= @payload.length
  end
end

class Puzzle

  attr_accessor :line, :input, :cursor, :versions

  def initialize(line)
    @cursor = 0
    @line = line
    build_bits(line)
    @input = Stream.new(@payload)
    @versions = []
  end

  def solve
    unpack(@input)
  end

  def unpack(stream)
    while !stream.eof?
      version = read_version
      type = btoa(stream.read(3))
      if type == 4
        p read_literal
      else
        length_type = stream.read(1) 
        length_size = length_type == '0' ? 15 : 11
        n = btoa(stream.read(length_size))
        # puts "subpacket type #{length_type}"
        if length_type == 0
          new_stream = Stream.new(stream.read(length))
          unpack(new_stream)
        else
          n.times{ unpack(stream) }
        end
      end
    end
  end

  def read_version(stream = @input)
    version = btoa(stream.read(3))
    @versions << version if version != 0
    version
  end

  def read_literal(stream = @input)
    str = ""
    while true
      word = stream.read(5)
      str += word[1..-1]
      return btoa(str) if word[0] == '0'
    end
  end

  def btoa(str)
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
p puzzle.versions.sum
