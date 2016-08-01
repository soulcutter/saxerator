# encoding: utf-8
require 'spec_helper'

describe 'Saxerator xml format', :nokogiri_only do
  let(:xml) { fixture_file('nested_elements.xml') }

  subject(:entry) do
    Saxerator.parser(xml) do |config|
      config.output_type = :xml
    end.for_tag(:entry).first
  end

  it { is_expected.to be_a(Nokogiri::XML::Node) }
  it 'looks like the original document' do
    expected_xml = <<-eos
<?xml version="1.0"?>
<entry>
  <id>1</id>
  <published>2012-01-01T16:17:00-06:00</published>
  <updated>2012-01-01T16:17:00-06:00</updated>
  <link href="https://example.com/blog/how-to-eat-an-airplane"/>
  <title>How to eat an airplane</title>
  <content type="html">&lt;p&gt;Airplanes are very large &#x2014; this can present difficulty in digestion.&lt;/p&gt;</content>
  <media:thumbnail url="http://www.gravatar.com/avatar/a9eb6ba22e482b71b266daadf9c9a080?s=80"/>
  <author>
    <name>Soul&lt;utter</name>
  </author>
  <contributor type="primary">
    <name>Jane Doe</name>
  </contributor>
  <contributor>
    <name>Leviticus Alabaster</name>
  </contributor>
</entry>
    eos
    expect(entry.to_xml).to eq(expected_xml)
  end
end
