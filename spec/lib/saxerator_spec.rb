# encoding: utf-8

require 'spec_helper'

describe Saxerator do
  def fixture_file(name)
    File.new(File.join(File.dirname(__FILE__), '..', 'fixtures', name))
  end

  context ".parser" do
    subject { parser }
    let(:parser) { Saxerator.parser(xml) }

    context "with a string with blurbs" do
      let(:xml) { "<blurbs><blurb>one</blurb><blurb>two</blurb><blurb>three</blurb></blurbs>" }

      it "should parse simple strings" do
        results = []
        subject.for_tag(:blurb).each { |x| results << x }
        results.should == ['one', 'two', 'three']
      end

      context "and one non-blurb" do
        let(:xml) { "<blurbs><blurb>one</blurb><blurb>two</blurb><blurb>three</blurb><notablurb>four</notablurb></blurbs>" }
        it "should only parse the requested tag" do
          results = []
          subject.for_tag(:blurb).each { |x| results << x }
          results.should == ['one', 'two', 'three']
          subject.for_tag(:notablurb).each { |x| results << x }
          results.should == ['one', 'two', 'three', 'four']
        end
      end
    end

    context "with a string with an element at multiple depths" do
      let(:xml) do
        <<-eos
          <publications>
            <book>
              <name>How to eat an airplane</name>
              <author>
                <name>Leviticus Alabaster</name>
                <name>Eunice Diesel</name>
              </author>
            </book>
            <book>
              <name>To wallop a horse in the face</name>
              <author>
                <name>Jeanne Clarewood</name>
              </author>
            </book>
            <article>
              <name>Is our children learning?</name>
              <author>
                <name>Hazel Nutt</name>
              </author>
            </article>
          </publication>
        eos
      end

      it "should only parse the requested tag depth" do
        results = []
        subject.at_depth(3).each { |x| results << x }
        results.should == [
          'How to eat an airplane', { 'name' => ['Leviticus Alabaster', 'Eunice Diesel'] },
          'To wallop a horse in the face', { 'name' => 'Jeanne Clarewood' },
          'Is our children learning?', { 'name' => 'Hazel Nutt' }
        ]
      end

      it "should only parse the requested tag depth and tag" do
        results = []
        subject.at_depth(3).for_tag(:name).each { |x| results << x }
        results.should == ['How to eat an airplane', 'To wallop a horse in the face', 'Is our children learning?']
      end

      it "should only parse tags nested inside the specified tag" do
        results = []
        subject.within(:article).each { |x| results << x }
        results.should == ['Is our children learning?', { 'name' => 'Hazel Nutt' }]
      end

      it "should only parse specified tags nested inside a specified tag" do
        results = []
        subject.for_tag(:name).within(:article).each { |x| results << x }
        results.should == ['Is our children learning?', 'Hazel Nutt'  ]
      end
    end

    context "with a file with blurbs" do
      let(:xml) { fixture_file('flat_blurbs.xml') }

      it "should parse simple strings" do
        results = []
        subject.for_tag(:blurb).each { |x| results << x }
        results.should == ['one', 'two', 'three']
      end

      it "should allow multiple operations on the same parser" do
        # This exposes a bug where if a File is not reset only the first
        # Enumerable method works as expected
        subject.for_tag(:blurb).first.should == 'one'
        subject.for_tag(:blurb).first.should == 'one'
      end
    end

    context "with a file with nested elements" do
      let(:xml) { fixture_file('nested_elements.xml') }
      subject { parser.for_tag(:entry).first }

      specify { subject['title'].should == 'How to eat an airplane' }
      specify { subject['author'].should == {'name' => 'Soulcutter'} }
      specify { subject['contributor'].should == [{'name' => 'Jane Doe'}, {'name' => 'Leviticus Alabaster'}] }
      specify { subject['content'].should == "<p>Airplanes are very large — this can present difficulty in digestion.</p>"}
      specify { subject['content'].attributes['type'].should == 'html' }
      specify { subject['contributor'][0].attributes['type'].should == 'primary' }
      specify { subject['contributor'][0]['name'].should == 'Jane Doe' }
    end
  end
end