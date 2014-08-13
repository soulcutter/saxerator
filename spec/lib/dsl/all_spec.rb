require 'spec_helper'

describe "Saxerator::FullDocument#all" do
  subject(:parser) { Saxerator.parser(xml) }

  let(:xml) do
    <<-eos
      <blurbs>
        <blurb>one</blurb>
        <blurb>two</blurb>
        <blurb>three</blurb>
        <notablurb>four</notablurb>
        <empty with="attribute"/>
      </blurbs>
    eos
  end

  it "should allow you to parse an entire document" do
    parser.all.should == {'blurb' => ['one', 'two', 'three'], 'notablurb' => 'four', 'empty' => {} }
  end

  context "with_put_attributes_in_hash" do
    subject(:parser) do
      Saxerator.parser(xml) { |config| config.put_attributes_in_hash! }
    end

    it "should allow you to parse an entire document" do
      parser.all.should == {'blurb' => ['one', 'two', 'three'], 'notablurb' => 'four', 'empty' => { "with" => "attribute"}}
    end
  end
end
