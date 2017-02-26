require 'spec_helper'

describe 'Saxerator::DSL#at_depth' do
  subject(:parser) { Saxerator.parser(xml) }

  let(:xml) do
    <<-eos
      <publications>
        <book>
          <name>How to eat an airplane</name>
          <author>Leviticus Alabaster</author>
        </book>
        <book>
          <name>To wallop a horse in the face</name>
          <author>Jeanne Clarewood</author>
        </book>
      </publications>
    eos
  end

  it 'parses elements at the requested tag depth' do
    expect(parser.at_depth(2).inject([], :<<)).to eq([
      'How to eat an airplane',
      'Leviticus Alabaster',
      'To wallop a horse in the face',
      'Jeanne Clarewood'
    ])
  end

  it 'works in combination with #for_tag' do
    expect(parser.at_depth(2).for_tag(:name).inject([], :<<)).to eq([
      'How to eat an airplane',
      'To wallop a horse in the face'
    ])
  end
end
