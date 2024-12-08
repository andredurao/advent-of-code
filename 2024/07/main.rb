class Solver
  attr_accessor :lines
  def initialize
    @lines = File.readlines(ARGV[0]).map(&:chomp)
  end

  def part1
    total = 0
    @lines.each do |line|
      values = line.split(/\D/).filter{|x| x.size > 0}.map(&:to_i)
      if valid_equation?(values[0], values[1..])
        total += values[0]
      end
    end
    total
  end

  def dumb_evaluation(items)
    while items.size > 1
      v1, op, v2 = items.shift(3)
      items.unshift([v1,v2].reduce(op))
    end
    items[0]
  end

  def valid_equation?(total, values)
    ops = [:+, :*]
    ops.repeated_permutation(values.size - 1).each do |perm|
      items = [values[0]]
      perm.each_with_index do |op, i|
        items << op
        items << values[i+1]
      end
      return true if total == eval(items.join) || total == dumb_evaluation(items)
    end
    false
  end
end

raise "usage: main.rb FILENAME" if ARGV.size == 0

solver = Solver.new
puts "part1: #{solver.part1}"
