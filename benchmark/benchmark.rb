$:.push File.expand_path('../../lib', __FILE__)
require 'saxerator'
require 'benchmark'

file = ARGV.shift
if !File.exists?(file)
  puts "Cannot find file #{file}"
  exit 1
end
file = File.new(file)

count = count2 = count3 = count4 = 0
Benchmark.bm do |x|
  x.report('for_tag') { Saxerator.parser(file).for_tag(:artist).each { count = count + 1 } }
  x.report('at_depth') { Saxerator.parser(file).at_depth(2).each { count2 = count2 + 1 } }
  x.report('within') { Saxerator.parser(file).within(:artists).each { count3 = count3 + 1 } }
  x.report('composite') { Saxerator.parser(file).for_tag(:name).within(:artist).at_depth(3).each { count4 = count4 + 1} }
end

puts "for_tag:   #{count} artist elements parsed"
puts "at_depth:  #{count2} elements parsed"
puts "within:    #{count3} artists children parsed"
puts "composite: #{count4} names within artist nested 3 tags deep parsed"
