# encoding: utf-8

require 'spec_helper'

describe Saxerator do
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

  context "output_type configuration" do
    subject(:parser) do
      Saxerator.parser(xml) { |config| config.output_type = output_type }
    end

    let(:xml) { "<foo><bar>baz</bar></foo>" }

    context "with config.output_type = :hash" do
      let(:output_type) { :hash }
      specify { parser.all.should == {'bar' => 'baz'} }
    end

    context "with an invalid config.output_type" do
      let(:output_type) { 'lmao' }
      specify { lambda { parser }.should raise_error(ArgumentError) }
    end
  end
end