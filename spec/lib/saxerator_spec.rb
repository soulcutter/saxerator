# encoding: utf-8

require 'spec_helper'

describe Saxerator do
  def fixture_file(name)
    File.new(File.join(File.dirname(__FILE__), '..', 'fixtures', name))
  end

  context ".parser" do
    subject { parser }
    let(:parser) { Saxerator.parser(xml) }

    context "with a string with blurbs and one non-blurb" do
      let(:xml) do
        <<-eos
          <blurbs>
            <blurb>one</blurb>
            <blurb>two</blurb>
            <blurb>three</blurb>
            <notablurb>four</notablurb>
          </blurbs>
        eos
      end

      it "should parse simple strings" do
        subject.for_tag(:blurb).inject([], :<<).should == ['one', 'two', 'three']
      end

      it "should only parse the requested tag" do
        subject.for_tag(:notablurb).inject([], :<<).should == ['four']
      end

      it "should allow you to parse an entire document" do
        subject.all.should == {'blurb' => ['one', 'two', 'three'], 'notablurb' => 'four'}
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
        subject.at_depth(2).inject([], :<<).should == [
          'How to eat an airplane', { 'name' => ['Leviticus Alabaster', 'Eunice Diesel'] },
          'To wallop a horse in the face', { 'name' => 'Jeanne Clarewood' },
          'Is our children learning?', { 'name' => 'Hazel Nutt' }
        ]
      end

      it "should only parse the requested tag depth and tag" do
        subject.at_depth(2).for_tag(:name).inject([], :<<).should == [
            'How to eat an airplane',
            'To wallop a horse in the face',
            'Is our children learning?'
        ]
      end

      it "should only parse tags nested inside the specified tag" do
        subject.within(:article).inject([], :<<).should == [
            'Is our children learning?',
            { 'name' => 'Hazel Nutt' }
        ]
      end

      it "should combine #for_tag and #within to parse the specified elements" do
        subject.for_tag(:name).within(:article).inject([], :<<).should == [
            'Is our children learning?',
            'Hazel Nutt'
        ]
      end
    end

    context "with a grand child" do
      let(:xml) do
         <<-eos
        <root>
          <children>
            <name>Rudy McMannis</name>
            <children>
              <name>Tom McMannis</name>
            </children>
            <grandchildren>
              <name>Mildred Marston</name>
            </grandchildren>
            <name>Anne Welsh</name>
          </children>
        </root>
        eos
      end

      it "should only parse children of the specified tag" do
        subject.child_of(:grandchildren).inject([], :<<).should == [
            'Mildred Marston'
        ]
      end

      it "should combine #for_tag and #child_of" do
        subject.for_tag(:name).child_of(:children).inject([], :<<).should == [
            'Rudy McMannis',
            'Tom McMannis',
            'Anne Welsh'
        ]
      end
    end

    context "with a file with blurbs" do
      let(:xml) { fixture_file('flat_blurbs.xml') }

      it "should parse simple strings" do
        subject.for_tag(:blurb).inject([], :<<).should == ['one', 'two', 'three']
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