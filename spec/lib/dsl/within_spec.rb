require 'spec_helper'

describe 'Saxerator::DSL#within' do
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

  it 'only parses elements nested within the specified tag' do
    expect(parser.within(:article).inject([], :<<)).to eq([
        'Is our children learning?',
        'Hazel Nutt'
    ])
  end

  it 'works in combination with #for_tag' do
    expect(parser.for_tag(:name).within(:article).inject([], :<<))
      .to eq(['Is our children learning?'])
  end
end
