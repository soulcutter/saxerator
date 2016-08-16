$LOAD_PATH.push File.expand_path('../../lib', __FILE__)
require 'saxerator'
require 'benchmark'

file = ARGV.shift
unless File.exist?(file)
  puts "Cannot find file #{file}"
  exit 1
end
file = File.new(file)

ADAPTERS = [:nokogiri, :ox].freeze

class SaxeratorBenchmark
  def initialize(file)
    @file = file
  end

  def with_adapter(adapter) # rubocop:disable Metrics/MethodLength
    puts '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    puts
    puts "Benchmark with :#{adapter} parser"
    puts
    puts '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    puts

    count = count2 = count3 = count4 = 0

    Benchmark.bm do |x|
      x.report('for_tag') do
        Saxerator.parser(@file) { |confing| confing.adapter = adapter }
                 .for_tag(:artist).each { count += 1 }
      end

      x.report('at_depth') do
        Saxerator.parser(@file) { |confing| confing.adapter = adapter }
                 .at_depth(2).each { count2 += 1 }
      end

      x.report('within') do
        Saxerator.parser(@file) { |confing| confing.adapter = adapter }
                 .within(:artists).each { count3 += 1 }
      end

      x.report('composite') do
        Saxerator.parser(@file) { |confing| confing.adapter = adapter }
                 .for_tag(:name)
                 .within(:artist).at_depth(3).each { count4 += 1 }
      end
    end

    puts
    puts '##########################################################'
    puts
    puts "for_tag:   #{count} artist elements parsed"
    puts "at_depth:  #{count2} elements parsed"
    puts "within:    #{count3} artists children parsed"
    puts "composite: #{count4} names within artist nested 3 tags deep parsed"
    puts
  end
end

saxerator_benchmark = SaxeratorBenchmark.new(file)

ADAPTERS.each { |adapter| saxerator_benchmark.with_adapter(adapter) }
