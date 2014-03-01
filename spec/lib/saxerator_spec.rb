# encoding: utf-8

require 'spec_helper'

describe Saxerator do
  context "#parser" do
    subject(:parser) { Saxerator.parser(xml) }

    context "with a File argument" do
      let(:xml) { fixture_file('flat_blurbs.xml') }

      it "should be able to parse it" do
        parser.all.should == {'blurb' => ['one', 'two', 'three']}
      end

      it "should allow multiple operations on the same parser" do
        # This exposes a bug where if a File is not reset only the first
        # Enumerable method works as expected
        parser.for_tag(:blurb).first.should == 'one'
        parser.for_tag(:blurb).first.should == 'one'
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
        parser.all.should == { 'name' => 'Illiterates that can read', 'author' => 'Eunice Diesel' }
      end
    end
  end

  context "configuration" do
    let(:xml) { "<foo><bar>baz</bar></foo>" }

    context "output type" do
      subject(:parser) do
        Saxerator.parser(xml) { |config| config.output_type = output_type }
      end

      context "with config.output_type = :hash" do
        let(:output_type) { :hash }
        specify { parser.all.should == {'bar' => 'baz'} }
      end

      context "with an invalid config.output_type" do
        let(:output_type) { 'lmao' }
        specify { expect { parser }.to raise_error(ArgumentError) }
      end
    end

    context "symbolize keys" do
      subject(:parser) do
        Saxerator.parser(xml) { |config| config.symbolize_keys! }
      end

      specify { parser.all.should == { :bar => 'baz' } }
      specify { parser.all.name.should == :foo }
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
        Saxerator.parser(xml) { |config| 
          config.ignore_namespaces! 
        }
      end

      specify {
        bar_count = 0
        parser.for_tag("bar").each do |tag|
          bar_count += 1
        end
        bar_count.should == 2
      }
    end

    context "with strip namespaces" do
      let(:xml) { "<ns1:foo><ns3:bar>baz</ns3:bar></ns1:foo>" }
      subject(:parser) do
        Saxerator.parser(xml) { |config| config.strip_namespaces! }
      end

      specify { parser.all.should == {'bar' => 'baz'} }
      specify { parser.all.name.should == 'foo' }

      context "combined with symbolize keys" do
        subject(:parser) do
          Saxerator.parser(xml) do |config|
            config.strip_namespaces!
            config.symbolize_keys!
          end
        end

        specify { parser.all.should == {:bar => 'baz'} }
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
          Saxerator.parser(xml) { |config| config.strip_namespaces! :ns1, :ns3 }
        end

        specify { parser.all.should == {'ns2:bar' => 'baz', 'bar' => 'biz'} }
        specify { parser.all.name.should == 'foo' }
      end
    end

  end

  context "configuration with put_attributes_in_hash!" do
    let(:xml) { '<foo foo="bar"><bar>baz</bar></foo>' }

    subject(:parser) do
      Saxerator.parser(xml) do |config|
        config.put_attributes_in_hash!
      end
    end

    it "should be able to parse it" do
      parser.all.should == { 'bar' => 'baz', 'foo' => 'bar' }
    end

  end

  context "configuration with put_attributes_in_hash! and config.output_type = :xml" do
    let(:xml) { '<foo foo="bar"><bar>baz</bar></foo>' }

    subject(:parser) do
      Saxerator.parser(xml) do |config|
        config.put_attributes_in_hash!
        config.output_type = :xml
      end
    end

    context "should raise error with " do
      specify { expect { parser }.to raise_error(ArgumentError) }
    end
  end

end
