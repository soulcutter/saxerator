# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'saxerator/version'
require 'rake' # for FileList

Gem::Specification.new do |s|
  s.name        = 'saxerator'
  s.version     = Saxerator::VERSION
  s.authors     = ['Bradley Schaefer']
  s.email       = ['bradley.schaefer@gmail.com']
  s.homepage    = 'https://github.com/soulcutter/saxerator'
  s.summary     = 'A SAX-based XML parser for parsing large files into manageable chunks'
  s.description = <<-eos
    Saxerator is a SAX-based xml parser designed for parsing very large files into manageable chunks. Rather than
    dealing directly with SAX callback methods, Saxerator gives you Enumerable access to chunks of an xml document.
    This approach is ideal for large xml files containing a collection of elements that you can process
    independently.
  eos
  s.license     = 'MIT'

  s.rubyforge_project = 'saxerator'

  s.files = FileList[
    'LICENSE',
    'README.md',
    'saxerator.gemspec',
    'lib/**/*.rb',
    'spec/**/*.*',
    'benchmark/**/*.rb',
    'Gemfile',
    'Guardfile',
    'Rakefile',
    '.rvmrc',
    '.gitignore'
  ]
  s.test_files    = FileList['spec/**/*.*']
  s.executables   = []
  s.require_paths = ['lib']

  s.add_runtime_dependency 'nokogiri'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'ipsum'
end
