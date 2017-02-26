require 'spec_helper'

describe 'Saxerator::DSL#for_tags' do
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

  it 'only selects the specified tags' do
    expect(parser.for_tags(%w(blurb1 blurb3)).inject([], :<<)).to eq(['one', 'three'])
  end

  it 'raises an ArgumentError for a non-Array argument' do
    expect { parser.for_tags('asdf') }.to raise_error ArgumentError
  end
end
