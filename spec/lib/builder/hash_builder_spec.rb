# encoding: utf-8
require 'spec_helper'

describe "Saxerator (default) hash format" do
  let(:xml) { fixture_file('nested_elements.xml') }
  subject(:entry) { Saxerator.parser(xml).for_tag(:entry).first }

  # string
  specify { entry['title'].should == 'How to eat an airplane' }

  # hash and cdata inside name
  specify { entry['author'].should == {'name' => 'Soul<utter'} }

  # array of hashes
  specify { entry['contributor'].should == [{'name' => 'Jane Doe'}, {'name' => 'Leviticus Alabaster'}] }

  # attributes on a hash
  specify { entry['contributor'][0].attributes['type'].should == 'primary' }

  # attributes on a string
  specify { entry['content'].attributes['type'].should == 'html' }

  # name on a hash
  specify { entry.name.should == 'entry' }

  # name on a string
  specify { entry['title'].name.should == 'title' }

  # name on an array
  specify { entry['contributor'].name.should == 'contributor' }

  # character entity decoding
  specify { entry['content'].should == "<p>Airplanes are very large — this can present difficulty in digestion.</p>" }

  # empty element
  specify { entry['media:thumbnail'].should == {} }
end