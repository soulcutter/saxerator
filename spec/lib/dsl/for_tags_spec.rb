require 'spec_helper'

describe "Saxerator::DSL#for_tags" do
  subject(:parser) { Saxerator.parser(xml) }

  let(:xml) do
    <<-eos
      <blurbs>
        <blurb1>one</blurb1>
        <blurb2>two</blurb2>
        <blurb3>three</blurb3>
      </blurbs>
    eos
  end

  it "should only select the specified tags" do
    parser.for_tags(%w(blurb1 blurb3)).inject([], :<<).should == ['one', 'three']
  end
end