require 'spec_helper'

describe 'Saxerator::DSL#with_attribute' do
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

  it 'matches tags with the specified attributes' do
    expect(subject.with_attribute(:type).inject([], :<<)).to eq([
        'Leviticus Alabaster',
        'Eunice Diesel'
    ])
  end

  it 'matches tags with the specified attributes' do
    expect(subject.with_attribute(:type, :primary).inject([], :<<)).to eq(['Leviticus Alabaster'])
  end
end
