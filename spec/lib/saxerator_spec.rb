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

    context "with a file with blurbs" do
      let(:xml) { fixture_file('flat_blurbs.xml') }

      it "should parse simple strings" do
        results = []
        subject.for_tag(:blurb).each { |x| results << x }
        results.should == ['one', 'two', 'three']
      end
    end

    context "with a file with nested elements" do
      let(:xml) { fixture_file('nested_elements.xml') }

      it "should give access to nested elements" do
        pending do
          subject.for_tag(:entry).first['title'].should == 'How to eat an airplane'
        end
      end
    end
  end
end