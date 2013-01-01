Saxerator is a streaming xml-to-hash DSL designed for working with very large xml files by
giving you [Enumerable](http://apidock.com/ruby/Enumerable) access to manageable chunks of a document.

## Basic example

```ruby
require 'saxerator'

parser = Saxerator.parser(File.new("rss.xml"))

parser.for_tag(:item).each do |item|
  # where the xml contains <item><title>...</title><author>...</author></item>
  # item will look like {'title' => '...', 'author' => '...'}
  puts "#{item['title']}: #{item['author']}"
end
```

#### Legal Stuff ####
Copyright © Bradley Schaefer. MIT License (see LICENSE file).
