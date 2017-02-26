require 'spec_helper'

RSpec.describe Saxerator do
  context '#parser' do
    subject(:parser) do
      Saxerator.parser(xml)
    end

    context 'with a File argument' do
      let(:xml) { fixture_file('flat_blurbs.xml') }

      it 'can parse it' do
        expect(parser.all).to eq('blurb' => %w(one two three))
      end

      it 'allows multiple operations on the same parser' do
        # This exposes a bug where if a File is not reset only the first
        # Enumerable method works as expected
        expect(parser.for_tag(:blurb).first).to eq('one')
        expect(parser.for_tag(:blurb).first).to eq('one')
      end
    end

    context 'with a String argument' do
      let(:xml) do
        <<-eos
        <book>
          <name>Illiterates that can read</name>
          <author>Eunice Diesel</author>
        </book>
        eos
      end

      it 'can parse it' do
        expect(parser.all).to eq('name' => 'Illiterates that can read', 'author' => 'Eunice Diesel')
      end
    end
  end

  context 'configuration' do
    let(:xml) { '<foo><bar foo="bar">baz</bar></foo>' }

    context 'output type' do
      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.output_type = output_type
        end
      end

      context 'with config.output_type = :hash' do
        let(:output_type) { :hash }
        specify { expect(parser.all).to eq('bar' => 'baz') }
      end

      context 'with config.output_type = :xml' do
        let(:output_type) { :xml }
        specify { expect(parser.all).to be_a REXML::Document }
        specify { expect(parser.all.to_s).to include '<bar foo="bar">' }
      end

      context 'with an invalid config.output_type' do
        let(:output_type) { 'lmao' }
        specify { expect { parser }.to raise_error(ArgumentError) }
      end
    end

    context 'symbolize keys' do
      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.symbolize_keys!
          config.output_type = :hash
        end
      end

      specify { expect(parser.all).to eq(bar: 'baz') }
      specify { expect(parser.all.name).to eq(:foo) }

      it 'will symbolize attributes' do
        parser.for_tag('bar').each do |tag|
          expect(tag.attributes).to include(foo: 'bar')
        end
      end
    end

    context 'with ignore namespaces' do
      let(:xml) do
        <<-eos
        <ns1:foo xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ns1="http://foo.com" xmlns:ns3="http://bar.com">
        <ns3:bar>baz</ns3:bar>
        <ns3:bar bar="bar" ns1:foo="foo" class="class">bax</ns3:bar>
        </ns1:foo>
        eos
      end

      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.ignore_namespaces!
        end
      end

      specify do
        bar_count = 0
        parser.for_tag('bar').each do |_|
          bar_count += 1
        end
        expect(bar_count).to eq(2)
      end
    end

    context 'with strip namespaces' do
      let(:xml) do
        <<-XML
        <ns1:foo xmlns:ns1="http://foo.com" xmlns:ns3="http://baz.com">
        <ns3:bar>baz</ns3:bar>
        </ns1:foo>
        XML
      end
      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.strip_namespaces!
        end
      end

      specify { expect(parser.all).to eq('bar' => 'baz') }
      specify { expect(parser.all.name).to eq('foo') }

      context 'combined with symbolize keys' do
        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.strip_namespaces!
            config.symbolize_keys!
          end
        end

        specify { expect(parser.all).to eq(bar: 'baz') }
      end

      context 'for specific namespaces' do
        let(:xml) do
          <<-XML
          <ns1:foo xmlns:ns1="http://foo.com" xmlns:ns2="http://bar.com" xmlns:ns3="http://baz.com">
          <ns2:bar>baz</ns2:bar>
          <ns3:bar>biz</ns3:bar>
          </ns1:foo>
          XML
        end
        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.strip_namespaces! :ns1, :ns3
          end
        end

        specify { expect(parser.all).to eq('ns2:bar' => 'baz', 'bar' => 'biz') }
        specify { expect(parser.all.name).to eq('foo') }
      end
    end
  end

  context 'configuration with put_attributes_in_hash!' do
    let(:xml) { '<foo foo="bar"><bar>baz</bar></foo>' }

    subject(:parser) do
      Saxerator.parser(xml) do |config|
        config.put_attributes_in_hash!
      end
    end

    it 'can parse it' do
      expect(parser.all).to eq('bar' => 'baz', 'foo' => 'bar')
    end

    context 'with configured output_type :xml' do
      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.put_attributes_in_hash!
          config.output_type = :xml
        end
      end

      context 'raises error with' do
        specify { expect { parser }.to raise_error(ArgumentError) }
      end
    end

    context 'with symbolize_keys!' do
      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.put_attributes_in_hash!
          config.symbolize_keys!
        end
      end

      it 'will symbolize attribute hash keys' do
        expect(parser.all.to_hash).to include(bar: 'baz', foo: 'bar')
      end
    end
  end
end
