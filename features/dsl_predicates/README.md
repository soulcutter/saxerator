The DSL consists of predicates that may be combined to describe which elements Saxerator will enumerate over.
Saxerator will only enumerate over chunks of xml that match all of the combined predicates.

| Predicate        | Explanation |
|:-----------------|:------------|
| `all`            | Returns the entire document parsed into a hash. Cannot combine with other predicates
| `for_tag(name)`  | Elements whose name matches the given `name`
| `for_tags(names)`| Elements whose name is in the `names` Array
| `at_depth(n)`    | Elements `n` levels deep inside the root of an xml document. The root element itself is `n = 0`
| `within(name)`   | Elements nested anywhere within an element with the given `name`
| `child_of(name)` | Elements that are direct children of an element with the given `name`
| `with_attribute(name, value)` | Elements that have an attribute with a given `name` and `value`. If no `value` is given, matches any element with the specified attribute name present
| `with_attributes(attrs)` | Similar to `with_attribute` except takes an Array or Hash indicating the attributes to match
