class Fish
  def initialize(timer=9)
    @timer = timer
  end

  def transition(school)
    if @timer == 0
      @timer = 6
      school << Fish.new
    else
      @timer -= 1
    end
  end
  
  def to_i
    @timer
  end
end

line = File.readlines('input', chomp: true).first
items = line.split(',').map(&:to_i)
school = items.map{|x| Fish.new(x)}
p 'Initial', school.map(&:to_i)
1.upto(80) do |i|
  school.each{|fish| fish.transition(school)}
  #puts "after #{i} days: #{school.map(&:to_i)}"
  puts "after #{i} days: #{school.count} fish"
end
