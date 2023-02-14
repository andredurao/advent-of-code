require 'set'
require 'json'

def compare(l, r)
  sleep 0.5 ; p l ; p r ; p '==='
  while l.any? && r.any?
    vl, vr = l.shift, r.shift
    p [vl, vr]
    if vl.is_a?(Integer) && vr.is_a?(Integer)
      return true if vl < vr
      return false if vl > vr
    else
      vl = [vl] if !vl.is_a?(Array)
      vr = [vr] if !vr.is_a?(Array)
      result = compare(vl, vr)
      return result if [true, false].include?(result)
    end
  end
end


items = []
File.readlines(ARGV[0], chomp: true).each do |line|
  if !line.empty?
    items << JSON::parse(line)
  end
end

l, r = items.shift(2)
p "compare: #{compare(l,r)}"

exit 0
