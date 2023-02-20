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

# Usage: ruby main1.rb [file] [y]
# eg: ruby main1.rb example 10

positions = Set.new
sensors = []
beacons = []
Y = ARGV[1].to_i

File.readlines(ARGV[0], chomp: true).each do |line|
  m = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match(line)
  sensors << Pos.new(m[1].to_i, m[2].to_i)
  beacons << Pos.new(m[3].to_i, m[4].to_i)
end


sensors.zip(beacons) do |sensor, beacon|
  d = distance(sensor, beacon)

  min_y = sensor.y - d # min row that sensor can reach (top of the diamond)
  max_y = sensor.y + d # max row that sensor can reach (bottom of the diamond)

  # width at the Y row
  radius = sensor.y < Y ? max_y - Y : Y - min_y
  min_x = sensor.x - radius
  max_x = sensor.x + radius

  min_x.upto(max_x) do |x|
    positions.add([x, Y])
  end

  # remove existing beacons
  positions.delete(beacon.to_a)
end

p positions.count

