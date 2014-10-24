# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'saxerator/version'

Gem::Specification.new do |s|
  s.name        = 'saxerator'
  s.version     = Saxerator::VERSION
  s.authors     = ['Bradley Schaefer']
  s.email       = ['bradley.schaefer@gmail.com']
  s.homepage    = 'https://github.com/soulcutter/saxerator'
  s.summary     = 'A SAX-based XML-to-hash parser for parsing large files into manageable chunks'
  s.description = <<-eos
    Saxerator is a streaming xml-to-hash parser designed for working with very large xml files by
    giving you Enumerable access to manageable chunks of the document.
  eos
  s.license     = 'MIT'

  s.rubyforge_project = 'saxerator'

  s.files = [
    'LICENSE',
    'README.md',
    'saxerator.gemspec',
    'Gemfile',
    'Rakefile',
    '.gitignore',
    '.travis.yml'
  ] +
    Dir.glob('lib/**/*.rb') +
    Dir.glob('spec/**/*.*') +
    Dir.glob('benchmark/**/*.rb')
  s.test_files    = Dir.glob('spec/**/*.*')
  s.executables   = []
  s.require_paths = ['lib']

  s.add_runtime_dependency 'nokogiri', '>= 1.4.0'

  s.add_development_dependency 'rspec', '~> 3.1'
end
