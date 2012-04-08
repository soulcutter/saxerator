Saxerator
=========

Saxerator is a SAX-based xml parser designed for parsing very large files into manageable chunks. Rather than
dealing directly with SAX callback methods, Saxerator gives you Enumerable access to chunks of an xml document.
This approach is ideal for large xml files containing a collection of elements that you can process
independently.

Each xml chunk is parsed into a JSON-like Ruby Hash structure for consumption.

Examples
--------

```ruby
parser = Saxerator.parser(File.new("rss.xml"))

parser.for_tag(:item).each do |item|
  # where the xml contains <item><title>...</title><author>...</author></item>
  # item will look like {'title' => '...', 'author' => '...'}
  puts "#{item['title']}: #{item['author']}"
end

# a String is returned here since the given element contains only character data
puts "First title: #{parser.for_tag(:title).first}"
```

Compatibility
-------------
Known compatible rubies:

* MRI 1.9.3-p125
* MRI 1.9.2-p318
* JRuby 1.6.7 (with JRUBY_OPTS=--1.9)

Known incompatible rubies:

* MRI 1.9.2-p290 (Fiber segfaults)

Saxerator may work with other rubies that support Fiber.

FAQ
---
Why the name 'Saxerator'?

  > It's a combination of SAX + Enumerator.

Why use Saxerator over regular SAX parsing?

  > Much of the SAX parsing code I've written over the years has fallen into a pattern that Saxerator encapsulates:
  > marshall a chunk of an XML document into an object, operate on that object, then move on to the
  > next chunk. Saxerator alleviates the pain of marshalling and allows you to focus solely on operating on the
  > document chunk.

Why not DOM parsing?

  > DOM parsers load the entire document into memory. Saxerator only holds a single chunk in memory at a time. If your
  > document is very large, this can be an important consideration.

### Acknowledgements ###
Saxerator was inspired by [Nori](https://github.com/rubiii/nori) and [Gregory Brown](http://majesticseacreature.com/)'s
[Practicing Ruby](http://practicingruby.com/)