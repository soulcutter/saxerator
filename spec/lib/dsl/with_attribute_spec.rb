require 'spec_helper'

describe "Saxerator::DSL#with_attribute" do
  subject(:parser) { Saxerator.parser(xml) }

  let(:xml) do
    <<-eos
      <book>
        <name>How to eat an airplane</name>
        <author>
          <name type="primary">Leviticus Alabaster</name>
          <name type="foreword">Eunice Diesel</name>
        </author>
      </book>
    eos
  end

  it "should match tags with the specified attributes" do
    subject.with_attribute(:type).inject([], :<<).should == [
        'Leviticus Alabaster',
        'Eunice Diesel'
    ]
  end

  it "should match tags with the specified attributes" do
    subject.with_attribute(:type, :primary).inject([], :<<).should == ['Leviticus Alabaster']
  end
end