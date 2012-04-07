Saxerator
=========

Saxerator is a SAX-based xml parser designed for parsing very large files into manageable chunks. Rather than
dealing directly with SAX callback methods, Saxerator gives you Enumerable access to elements in an xml document.
This approach is ideal for large xml files that consist of collections of many smaller elements.

Examples
--------

```ruby
Saxerator.parser(File.new("rss.xml")).for_tag(:item).each do |item|
    puts "#{item['title']}: #{item['author']"
end
```
