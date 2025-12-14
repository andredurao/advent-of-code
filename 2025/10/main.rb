require 'chunky_png'

class Machine
  attr_accessor :lights, :buttons, :joltages, :lights_base10, :buttons_base10

  def initialize(line)
    build_lights(line)
    build_buttons(line)
    build_joltages(line)
    build_lights_decimal_base10
    build_buttons_base10
  end

  def to_s
    l = @lights.map{|light| light ? ?# : ?.}.join
    "#{l}"
  end

  private

  def build_lights_decimal_base10
    binary_str = lights.map{|ch| ch ? 1 : 0}.join
    @lights_base10 = binary_str.to_i(2)
  end

  def build_buttons_base10
    @buttons_base10 = []
    @buttons.each do |button|
      binary_value = ?0 * lights.size

      button.each{|index| binary_value[index] = ?1 if index < lights.size}

      @buttons_base10 << binary_value.to_i(2)
    end
  end

  def build_lights(line)
    @lights = []
    str = /\[.*\]/.match(line)[0]
    str[1..-2].chars do |ch|
      @lights << (ch == ?#)
    end
  end

  def build_buttons(line)
    @buttons = []
    strs = /\(.*\)/.match(line)[0].split
    strs.each do |group|
      @buttons << group[1..-2].split(?,).map(&:to_i)
    end
  end

  def build_joltages(line)
    str = /\{.*\}/.match(line)[0]
    @joltages = str[1..-2].split(?,).map(&:to_i)
  end
end

class Day10

  attr_reader :machines

  def initialize(filename=ARGV[0])
    raise "usage: main.rb FILENAME" if !filename

    build_machines(filename)
  end

  def part1
    res = 0

    p machines

    puts "part 1: #{res}"
  end

  private

  def build_machines(filename)
    @machines = []
    File.readlines(filename, chomp: true).map do |line|
      @machines << Machine.new(line)
    end
  end
end

app = Day10.new
app.part1
