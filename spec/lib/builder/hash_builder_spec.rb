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

    it { is_expected.to be_empty }

    it 'has attributes' do
      expect(element.attributes.keys).to eq ['url']
    end

    it 'has a name' do
      expect(element.name).to eq 'media:thumbnail'
    end
  end

  describe 'Saxerator elements with both text and element children format' do
    let(:xml) { fixture_file('mixed_text_with_elements.xml') }
    subject(:description) { Saxerator.parser(xml).for_tag(:description).first }

    it "emits an array of child elements in the order they appear in the document", :aggregate_failures do
      expect(description.map(&:class))
        .to eq([
          Saxerator::Builder::StringElement,
          Saxerator::Builder::ArrayElement,
          Saxerator::Builder::StringElement,
          Saxerator::Builder::HashElement
        ])
      # verifying the nodes are what we expect them to be
      expect(description.last.name).to eq 'p'
      expect(description.last.attributes).to include('id' => '3')
      expect(subject.first).to eq "This is a description."
    end
  end
end
