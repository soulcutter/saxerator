# encoding: utf-8

require 'spec_helper'

describe Saxerator do
  def fixture_file(name)
    File.new(File.join(File.dirname(__FILE__), '..', 'fixtures', name))
  end

  context "#parser" do
    subject(:parser) { Saxerator.parser(xml) }

    context "with a File argument" do
      let(:xml) { fixture_file('flat_blurbs.xml') }

      it "should be able to parse it" do
        parser.all.should == {'blurb' => ['one', 'two', 'three']}
      end

      it "should allow multiple operations on the same parser" do
        # This exposes a bug where if a File is not reset only the first
        # Enumerable method works as expected
        parser.for_tag(:blurb).first.should == 'one'
        parser.for_tag(:blurb).first.should == 'one'
      end
    end

    context "with a String argument" do
      let(:xml) do
        <<-eos
          <book>
            <name>Illiterates that can read</name>
            <author>Eunice Diesel</author>
          </book>
        eos
      end

      it "should be able to parse it" do
        parser.all.should == { 'name' => 'Illiterates that can read', 'author' => 'Eunice Diesel' }
      end
    end
  end

  context "block_variable format" do
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
    specify { entry['content'].should == "<p>Airplanes are very large — this can present difficulty in digestion.</p>"}

    # empty element
    specify { entry['media:thumbnail'].should == {} }
  end
end