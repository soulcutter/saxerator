# encoding: utf-8
require 'spec_helper'

describe 'Saxerator (default) hash format' do
  let(:xml) { fixture_file('nested_elements.xml') }
  subject(:entry) { Saxerator.parser(xml).for_tag(:entry).first }

  # string
  specify { expect(entry['title']).to eq('How to eat an airplane') }

  # hash and cdata inside name
  specify { expect(entry['author']).to eq('name' => 'Soul<utter') }

  # array of hashes
  specify do
    expect(entry['contributor'])
      .to eq([{ 'name' => 'Jane Doe' }, { 'name' => 'Leviticus Alabaster' }])
  end

  # attributes on a hash
  specify { expect(entry['contributor'][0].attributes['type']).to eq('primary') }

  # attributes on a string
  specify { expect(entry['content'].attributes['type']).to eq('html') }

  # name on a hash
  specify { expect(entry.name).to eq('entry') }

  # name on a string
  specify { expect(entry['title'].name).to eq('title') }

  describe '#to_s' do
    it 'preserves the element name' do
      expect(entry['title'].to_a.name).to eq('title')
    end
  end

  describe '#to_h' do
    it 'preserves the element name' do
      expect(entry.to_h.name).to eq('entry')
    end
  end

  describe '#to_a' do
    it 'preserves the element name on a parsed hash' do
      expect(entry.to_a.name).to eq('entry')
    end

    it 'converts parsed hashes to nested key/value pairs (just like regular hashes)' do
      expect(entry.to_a.first).to eq(['id', '1'])
    end

    it 'preserves the element name on a parsed string' do
      expect(entry['title'].to_a.name).to eq('title')
    end

    it 'preserves the element name on an array' do
      expect(entry['contributor'].to_a.name).to eq 'contributor'
    end
  end

  # name on an array
  specify { expect(entry['contributor'].name).to eq('contributor') }

  # character entity decoding
  specify do
    expect(entry['content'])
      .to eq('<p>Airplanes are very large — this can present difficulty in digestion.</p>')
  end

  context 'parsing an empty element' do
    subject(:element) { entry['media:thumbnail'] }

    it 'behaves somewhat like nil' do
      expect(element).to be_nil
      expect(!element).to be true
      expect(element.to_s).to eq('')
      expect(element.to_h).to eq({})
    end

    it { is_expected.to be_empty }

    it 'has attributes' do
      expect(element.attributes.keys).to eq ['url']
    end

    [:to_s, :to_h, :to_a].each do |conversion|
      it "preserves the element name through ##{conversion}" do
        expect(element.send(conversion).name).to eq 'media:thumbnail'
      end
    end

    [:to_s, :to_h].each do |conversion|
      it "preserves attributes through ##{conversion}" do
        expect(element.send(conversion).attributes.keys).to eq ['url']
      end
    end
  end
end
