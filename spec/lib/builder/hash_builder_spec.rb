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
  context "parsing an empty element" do
    subject(:element) { entry['media:thumbnail'] }

    it "behaves somewhat like nil" do
      element.should be_nil
      (!element).should eq true
      element.to_s.should eq ''
      element.to_h.should eq Hash.new
    end

    it { should be_empty }

    it "has attributes" do
      element.attributes.keys.should eq ['url']
    end

    [:to_s, :to_h].each do |conversion|
      it "preserves attributes through ##{conversion}" do
        element.send(conversion).attributes.keys.should eq ['url']
      end
    end
  end
end
