# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'saxerator/version'
require 'rubygems/package_task'

Gem::Specification.new do |s|
  s.name        = 'saxerator'
  s.version     = Saxerator::VERSION
  s.authors     = ['Bradley Schaefer']
  s.email       = ['bradley.schaefer@gmail.com']
  s.homepage    = 'https://github.com/soulcutter/saxerator'
  s.summary     = 'A SAX-based XML parser for parsing large files into manageable chunks'
  s.description = 'A SAX-based XML parser for parsing large files into manageable chunks'

  s.required_ruby_version = '>= 1.9.2'

  s.rubyforge_project = 'saxerator'

  s.files = FileList[
    'LICENSE',
    'README.md',
    'saxerator.gemspec',
    'lib/**/*.rb',
    'spec/**/*.*',
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

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'simplecov'
end
