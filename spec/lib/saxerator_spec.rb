# encoding: utf-8

require 'spec_helper'

RSpec.shared_examples_for Saxerator do |adapter|
  describe "(#{adapter}): Saxerator" do
    context "#parser" do
      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.adapter = adapter
        end
      end

      context "with a File argument" do
        let(:xml) { fixture_file('flat_blurbs.xml') }

        it "should be able to parse it" do
          expect(parser.all).to eq({'blurb' => ['one', 'two', 'three']})
        end

        it "should allow multiple operations on the same parser" do
          # This exposes a bug where if a File is not reset only the first
          # Enumerable method works as expected
          expect(parser.for_tag(:blurb).first).to eq('one')
          expect(parser.for_tag(:blurb).first).to eq('one')
        end
      end

      context "with a String argument" do
        let(:xml) do
          <<-eos
          <book>
            <name>Illiterates that can read</name>
            <author>Eunice Diesel</author>
          </book>
          eos
        end

        it "should be able to parse it" do
          expect(parser.all).to eq({ 'name' => 'Illiterates that can read', 'author' => 'Eunice Diesel' })
        end
      end
    end

    context "configuration" do
      let(:xml) { '<foo><bar foo="bar">baz</bar></foo>' }

      context "output type" do
        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.adapter = adapter
            config.output_type = output_type
          end
        end

        context "with config.output_type = :hash" do
          let(:output_type) { :hash }
          specify { expect(parser.all).to eq('bar' => 'baz') }
        end

        context "with an invalid config.output_type" do
          let(:output_type) { 'lmao' }
          specify { expect { parser }.to raise_error(ArgumentError) }
        end
      end

      context "symbolize keys" do
        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.symbolize_keys!
            config.output_type = :hash
          end
        end

        specify { expect(parser.all).to eq(:bar => 'baz') }
        specify { expect(parser.all.name).to eq(:foo) }

        it 'will symbolize attributes' do
          parser.for_tag('bar').each do |tag|
            expect(tag.attributes).to include(:foo => 'bar')
          end
        end
      end

      context "with ignore namespaces" do
        let(:xml) { <<-eos
<ns1:foo xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ns1="http://foo.com" xmlns:ns3="http://bar.com">
  <ns3:bar>baz</ns3:bar>
  <ns3:bar bar="bar" ns1:foo="foo" class="class">bax</ns3:bar>
</ns1:foo>
        eos
        }

        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.adapter = adapter
            config.ignore_namespaces!
          end
        end

        specify {
          bar_count = 0
          parser.for_tag("bar").each do |tag|
            bar_count += 1
          end
          expect(bar_count).to eq(2)
        }
      end

      context "with strip namespaces" do
        let(:xml) { "<ns1:foo><ns3:bar>baz</ns3:bar></ns1:foo>" }
        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.adapter = adapter
            config.strip_namespaces!
          end
        end

        specify { expect(parser.all).to eq({'bar' => 'baz'}) }
        specify { expect(parser.all.name).to eq('foo') }

        context "combined with symbolize keys" do
          subject(:parser) do
            Saxerator.parser(xml) do |config|
              config.adapter = adapter
              config.strip_namespaces!
              config.symbolize_keys!
            end
          end

          specify { expect(parser.all).to eq({:bar => 'baz'}) }
        end

        context "for specific namespaces" do
          let(:xml) do
            <<-XML.gsub /^ {10}/, ''
          <ns1:foo>
            <ns2:bar>baz</ns2:bar>
            <ns3:bar>biz</ns3:bar>
          </ns1:foo>
            XML
          end
          subject(:parser) do
            Saxerator.parser(xml) do |config|
              config.adapter = adapter
              config.strip_namespaces! :ns1, :ns3
            end
          end

          specify { expect(parser.all).to eq({'ns2:bar' => 'baz', 'bar' => 'biz'}) }
          specify { expect(parser.all.name).to eq('foo') }
        end
      end

    end

    context "configuration with put_attributes_in_hash!" do
      let(:xml) { '<foo foo="bar"><bar>baz</bar></foo>' }

      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.adapter = adapter
          config.put_attributes_in_hash!
        end
      end

      it "should be able to parse it" do
        expect(parser.all).to eq({ 'bar' => 'baz', 'foo' => 'bar' })
      end

      context 'with configured output_type :xml' do
        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.adapter = adapter
            config.put_attributes_in_hash!
            config.output_type = :xml
          end
        end

        context "should raise error with " do
          specify { expect { parser }.to raise_error(ArgumentError) }
        end
      end

      context 'with symbolize_keys!' do
        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.adapter = adapter
            config.put_attributes_in_hash!
            config.symbolize_keys!
          end
        end

        it 'will symbolize attribute hash keys' do
          expect(parser.all.to_hash).to include(:bar => 'baz', :foo => 'bar')
        end
      end
    end
  end
end

describe Saxerator do
  it_behaves_like Saxerator, :ox
  it_behaves_like Saxerator, :nokogiri

  context 'configuration' do
    let(:xml) { '<foo><bar foo="bar">baz</bar></foo>' }

    context 'output type' do
      subject(:parser) do
        Saxerator.parser(xml) do |config|
          config.adapter = adapter
          config.output_type = output_type
        end
      end

      context 'ox adapter' do
        let(:adapter) { :ox }

        context 'with config.output_type = :xml' do
          let(:output_type) { :xml }
          specify { expect { parser }.to raise_error(ArgumentError) }
        end
      end

      context 'nokogiri adapter' do
        let(:adapter) { :nokogiri }

        context 'with config.output_type = :xml' do
          let(:output_type) { :xml }
          specify { expect(parser.all).to be_a Nokogiri::XML::Document }
          specify { expect(parser.all.to_s).to include '<bar foo="bar">' }
        end
      end
    end
  end
end
