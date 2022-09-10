# encoding: utf-8

require 'spec_helper'

describe 'Saxerator xml format' do
  let(:xml) { fixture_file('nested_elements.xml') }

  subject(:entry) do
    Saxerator.parser(xml) do |config|
      config.output_type = :xml
    end.for_tag(:entry).first
  end

  it { is_expected.to be_a(REXML::Document) }
  it 'looks like the original document' do
    expected_xml = '<?xml version=\'1.0\' encoding=\'UTF-8\'?><entry><id>1</id><published>2012-01-01T16:17:00-06:00</published><updated>2012-01-01T16:17:00-06:00</updated><link href="https://example.com/blog/how-to-eat-an-airplane"/><title>How to eat an airplane</title><content type="html">&lt;p&gt;Airplanes are very large — this can present difficulty in digestion.&lt;/p&gt;</content><media:thumbnail url="http://www.gravatar.com/avatar/a9eb6ba22e482b71b266daadf9c9a080?s=80"/><author><name>Soul&lt;utter</name></author><contributor type="primary"><name>Jane Doe</name></contributor><contributor><name>Leviticus Alabaster</name></contributor></entry>' # rubocop:disable Metrics/LineLength
    expect(entry.to_s).to eq(expected_xml)
  end

  context 'when XML content is not-UTF-8' do
    let(:xml) do
      '<?xml version="1.0" encoding="iso-8859-1"?><feed><entry><title>Norrlandsvägen</title></entry></feed>'.encode('iso-8859-1')
    end

    let(:title) do
      Saxerator.parser(StringIO.new(xml)) do |config|
        config.output_type = :xml
      end.for_tag(:title).first
    end

    subject(:text) do
      title.root.get_text.value
    end

    it 'REXML text uses UTF-8' do
      expect(text.encoding.name).to eq('UTF-8')
    end
  end
end
