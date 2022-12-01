current = max = 0
File.readlines(ARGV[0]).each do |line|
  current += line.to_i if line.chomp! != ''
  if line == ''
    max = [max, current].max
    current = 0
  end
end
p max # usage: ruby main1.rb input01.txt
