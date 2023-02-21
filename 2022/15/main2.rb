require 'set'

class Pos
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x ; @y = y
  end

  def to_a
    [x, y]
  end

  def inspect
    "<x:#{x} y:#{y}>"
  end
end

def distance(p1, p2)
  (p1.x - p2.x).abs + (p1.y - p2.y).abs
end

def filter_value(value)
  return 0 if value < 0
  return 4_000_000 if value > 4_000_000
  value
end

def radar(sensor, d, y)
  min_y = sensor.y - d # min row that sensor can reach (top of the diamond)
  max_y = sensor.y + d # max row that sensor can reach (bottom of the diamond)

  return if !(min_y..max_y).include?(y)

  # width at the Y row
  radius = sensor.y < y ? max_y - y : y - min_y
  radius = radius.abs
  min_x = sensor.x - radius
  max_x = sensor.x + radius

  [filter_value(min_x), filter_value(max_x)]
end

def zip_ranges(ranges)
  range = (-1..-1)
  result = []
  ranges.sort.each_with_index do |vals, index|
    min, max = vals

    if range.first == -1
      range = (min..max)
      next
    end

    if range.cover?(min..max)
      next
    elsif range.include?(min) && !range.include?(max)
      range = (range.first..max)
    else
      result << range
      range = (min..max)
    end
  end
  result << range
end

def tuning_frequency(pos)
  pos.x * 4_000_000 + pos.y
end

# Usage: ruby main2.rb [file]
# eg: ruby main2.rb example

positions = Set.new
sensors = []
beacons = []

File.readlines(ARGV[0], chomp: true).each do |line|
  m = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match(line)
  sensors << Pos.new(m[1].to_i, m[2].to_i)
  beacons << Pos.new(m[3].to_i, m[4].to_i)
end

# cache of distances
distances = []
sensors.zip(beacons) do |sensor, beacon|
  d = distance(sensor, beacon)
  distances << [sensor, d]
end

y = -1 ; result = nil
0.upto(4_000_000) do |y|
  ranges = distances.map do |sensor, d|
    radar(sensor, d, y)
  end.compact

  ranges = zip_ranges(ranges)
  if ranges.size > 1
    result = [y, ranges]
    break
  end
end

y, ranges = result
x = ranges[0].last + 1
p tuning_frequency(Pos.new(x, y))
p 'done'
