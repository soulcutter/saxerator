#!/usr/bin/env ruby
filename = ARGV.shift

unless filename
  puts "Syntax: ruby #{__FILE__} <filename>"
  exit 1
end

num_records = ARGV.shift || 100000
num_records = num_records.to_i

element = <<-eos
  <artist id="%i">
    <name>Rock Star %i</name>
    <active>true</active>
    <description>...</description>
    <genre>Rock,Metal</genre>
  </artist>
eos

puts "Writing #{num_records} sample records to #{filename}, this will take a while..."

File.open(filename, 'w') do |f|
  f.puts '<?xml version="1.0" encoding="UTF-8"?>'
  f.puts '<artists>'
  num_records.times do |count|
    f.puts(element % [count, count])
  end
  f.puts '</artists>'
end
puts "DONE!"
