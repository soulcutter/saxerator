require 'spec_helper'

describe "Saxerator::DSL#child_of" do
  subject(:parser) { Saxerator.parser(xml) }

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
    parser.child_of(:grandchildren).inject([], :<<).should == [
        'Mildred Marston'
    ]
  end

  it "should work in combination with #for_tag" do
    parser.for_tag(:name).child_of(:children).inject([], :<<).should == [
        'Rudy McMannis',
        'Tom McMannis',
        'Anne Welsh'
    ]
  end
end