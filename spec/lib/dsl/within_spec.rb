require 'spec_helper'

describe "Saxerator::DSL#within" do
  subject(:parser) { Saxerator.parser(xml) }

  let(:xml) do
    <<-eos
      <magazine>
        <name>The Smarterest</name>
        <article>
          <name>Is our children learning?</name>
          <author>Hazel Nutt</author>
        </article>
      </magazine>
    eos
  end

  it "should only parse elements nested within the specified tag" do
    parser.within(:article).inject([], :<<).should == [
        'Is our children learning?',
        'Hazel Nutt'
    ]
  end

  it "should work in combination with #for_tag" do
    parser.for_tag(:name).within(:article).inject([], :<<).should == ['Is our children learning?']
  end
end