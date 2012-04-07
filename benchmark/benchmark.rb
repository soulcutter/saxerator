$:.push File.expand_path('../../lib', __FILE__)
require 'saxerator'
require 'benchmark'

file = ARGV.shift
if !File.exists?(file)
  puts "Cannot find file #{file}"
  exit 1
end
file = File.new(file)

tag = ARGV.shift || :artist

count = 0
Benchmark.bm do |x|
  x.report { Saxerator.parser(file).for_tag(tag).each { count = count + 1 } }
end
puts "#{count} #{tag} elements parsed"