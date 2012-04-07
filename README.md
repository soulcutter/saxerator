Saxerator
=========

Saxerator is a SAX-based xml parser designed for parsing very large files into manageable chunks. Rather than
dealing directly with SAX callback methods, Saxerator gives you Enumerable access to elements in an xml document.
This approach is ideal for large xml files that consist of collections of many smaller elements.

Examples
--------

```ruby
Saxerator.parser(File.new("rss.xml")).for_tag(:item).each do |item|
    puts "#{item['title']}: #{item['author']}"
end
```

Compatibility
-------------
This library is known to work with the following rubies:

* MRI 1.9.3-p125
* JRuby 1.6.7 (with JRUBY_OPTS=--1.9)

Saxerator may work with other versions with support for Fiber.

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