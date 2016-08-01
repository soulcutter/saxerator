require 'spec_helper'

describe 'Saxerator::DSL#with_attributes' do
  subject(:parser) { Saxerator.parser(xml) }

  let(:xml) do
    <<-eos
      <book>
        <name>How to eat an airplane</name>
        <author>
          <name type="primary" ridiculous="true">Leviticus Alabaster</name>
          <name type="foreword" ridiculous="true">Eunice Diesel</name>
          <name type="foreword">Jackson Frylock</name>
        </author>
      </book>
    eos
  end

  it 'matches tags with the exact specified attributes' do
    expect(parser.with_attributes(type: :primary, ridiculous: 'true').inject([], :<<)).to eq([
        'Leviticus Alabaster'
    ])
  end

  it 'matches tags which have the specified attributes' do
    expect(parser.with_attributes(%w(type ridiculous)).inject([], :<<))
      .to eq(['Leviticus Alabaster', 'Eunice Diesel'])
  end

  it 'raises ArgumentError if you pass something other than a Hash or Array' do
    expect { parser.with_attributes('asdf') }.to raise_error ArgumentError
  end
end
