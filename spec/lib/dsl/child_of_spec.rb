require 'spec_helper'

describe 'Saxerator::DSL#child_of' do
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

  it 'only parses children of the specified tag' do
    expect(parser.child_of(:grandchildren).inject([], :<<)).to eq([
        'Mildred Marston'
    ])
  end

  it 'works in combination with #for_tag' do
    expect(parser.for_tag(:name).child_of(:children).inject([], :<<)).to eq([
        'Rudy McMannis',
        'Tom McMannis',
        'Anne Welsh'
    ])
  end
end
