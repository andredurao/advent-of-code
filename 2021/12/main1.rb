class Node
  attr_accessor :name
  def initialize(name) ; @name = name ; end
  def start? ; name == 'start' ; end
  def end? ; name == 'end' ; end
  def big? ; name.upcase == name ; end
  def small? ; name.upcase != name ; end
end

class Puzzle
  attr_accessor :map, :items, :indexes, :results
  def initialize(lines)
    @results = []
    build_paths(lines)
  end

  def valid_path?(path)
    return true if path.empty?
    nodes = {}
    path.each do |node|
      nodes[node] ||= 0
      nodes[node] += 1
    end
    nodes.each do |node, count|
      return false if count > 1 && (small?(node) || start?(node) || finish?(node))
    end
    true
  end

  def solve(node, path=[])
    path << node
    if finish?(node)
      @results << path
      return
    end
    if !valid_path?(path)
      return
    else
      #puts "solve #{node} -> #{path.join(' ')}"
      conns = connections(node)
      #puts "#{node} => #{conns}"
      conns.each do |conn|
        solve(conn, path.clone)
      end
    end
  end

  def connections(node)
    result = []
    @map[@indexes[node]].each_with_index do |value, index|
      result << @items[index] if value
    end
    result
  end

  def build_paths(lines)
    # build an adjacency matrix
    @items = []
    lines.each do |line|
      @items = @items | line.split('-')
    end
    @indexes = {}
    @items.each_with_index{|item, index| @indexes[item] = index}
    @map = []
    @items.size.times{ @map << Array.new(@items.size) }
    lines.each do |line|
      from, to = line.split('-')
      @map[@indexes[from]][@indexes[to]] = 1
      @map[@indexes[to]][@indexes[from]] = 1
    end
  end

  def start?(name) ; name == 'start' ; end
  def finish?(name) ; name == 'end' ; end
  def big?(name) ; name.upcase == name ; end
  def small?(name) ; name.upcase != name ; end
  def debug
    puts "\t#{@items.join("\t")}"
    @map.each_with_index do |row, index|
      puts "#{@items[index]}\t#{row.join("\t")}"
    end
  end
end
lines = File.readlines(ARGV[0], chomp: true)
puzzle = Puzzle.new(lines)
puzzle.debug
puzzle.solve('start')
puzzle.results.each{|result| p result.join('-')}
p puzzle.results.size
