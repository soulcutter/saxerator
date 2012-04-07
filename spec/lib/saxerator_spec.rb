require 'spec_helper'

describe Saxerator do
  context ".parser" do
    subject { parser }
    let(:parser) { Saxerator.parser(xml) }

    context "with a string" do
      let(:xml) { "<blurbs><blurb>one</blurb><blurb>two</blurb><blurb>three</blurb></blurbs>" }

      it { should be }

      it "should parse simple strings" do
        results = []
        subject.for_tag(:blurb).each { |x| results << x }
        results.should == ['one', 'two', 'three']
      end
    end

    context "with a file" do
      let(:xml) { File.new(File.join(File.dirname(__FILE__), '..', 'fixtures', 'flat_blurbs.xml')) }

      it { should be }

      it "should parse simple strings" do
        results = []
        subject.for_tag(:blurb).each { |x| results << x }
        results.should == ['one', 'two', 'three']
      end
    end
  end
end