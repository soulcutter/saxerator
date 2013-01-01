Feature: all

  Saxerator is designed for streaming parsing, however if no other predicates
  are specified then you may request for the entire document to be parsed.

    """ruby
    Saxerator.parser(xml).all # => great big hash
    """

  Scenario: all predicate
    Given a file named "example.xml" with:
      """xml
      <blurbs>
        <blurb>one</blurb>
        <blurb>two</blurb>
        <blurb>three</blurb>
        <notablurb>four</notablurb>
      </blurbs>
      """
    And a file named "all_predicate.rb" with:
      """ruby
      require 'saxerator'

      puts Saxerator.parser(File.new('example.xml')).all
      """
    When I run `ruby all_predicate.rb`
    Then the output should contain:
      """
      {"blurb"=>["one", "two", "three"], "notablurb"=>"four"}
      """
