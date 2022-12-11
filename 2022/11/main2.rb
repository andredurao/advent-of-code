def log(x)
  puts(x) if ENV['DEBUG']
end

class Monkey
  attr_accessor :id, :items, :operation, :divisible, :dst_if_true, :dst_if_false, :gcd, :count
  def initialize(stack)
    @id = /Monkey (\d+):/.match(stack.shift)[1].to_i
    @items = /Starting items: (.*)$/.match(stack.shift)[1].split(', ').map(&:to_i)
    @operation = /Operation: (.*)/.match(stack.shift)[1]
    @divisible = /Test: divisible by (\d+)/.match(stack.shift)[1].to_i
    @dst_if_true = /If true: throw to monkey (\d+)/.match(stack.shift)[1].to_i
    @dst_if_false = /If false: throw to monkey (\d+)/.match(stack.shift)[1].to_i
    @count = 0
  end

  def execute(monkeys)
    log("Monkey #{id}:")
    while items.any?
      @count += 1
      old = items.shift
      log("  Monkey inspects an item with a worry level of #{old}.")
      log("  operate: #{operation}")
      new = 0
      eval(operation)
      new %= gcd
      is_divisible = new % divisible == 0
      log("  Current worry level (#{new}) is #{ is_divisible ? '' : 'not ' }divisible by #{@divisible}.")
      dst = is_divisible ? dst_if_true : dst_if_false
      log("  Item with worry level #{new} is thrown to monkey #{dst}.")
      monkeys[dst].items << new
      log("")
    end
  end
end

monkeys = {}
ids = []
stack = []
File.readlines(ARGV[0], chomp: true).each do |line|
  if line.empty?
    monkey = Monkey.new(stack)
    monkeys[monkey.id] = monkey
    ids << monkey.id
  else
    stack << line
  end
end

gcd = monkeys.values.map(&:divisible).reduce(:*)
p gcd
monkeys.each do |id, monkey|
  monkey.gcd = gcd
end

1.upto(ARGV[1].to_i) do |i|
  # p i
  ids.each{|id| monkeys[id].execute(monkeys)}
  # puts
  ids.each do |id|
    # puts("Monkey #{id}: #{monkeys[id].items}")
  end
end

puts
counts = []
ids.each do |id|
  puts("Monkey #{id} inspected items #{monkeys[id].count} times.")
  counts << monkeys[id].count
end
counts.sort!
p(counts[-1] * counts[-2])
