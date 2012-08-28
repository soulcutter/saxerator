require 'spec_helper'

describe "Saxerator::DSL#for_tag" do
  subject(:parser) { Saxerator.parser(xml) }

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

  it "should only select the specified tag" do
    parser.for_tag(:blurb).inject([], :<<).should == ['one', 'two', 'three']
  end
end