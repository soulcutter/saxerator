module Saxerator
  module Builder
    extend self

    def valid?(type)
      Builder.const_defined? "#{camel_case(type)}Builder"
    end

    def to_class(type)
      Builder.const_get("#{camel_case(type)}Builder")
    end

    def camel_case(str)
      str = str.to_s
      return str if str !~ /_/ && str =~ /[A-Z]+.*/
      str.split('_').map{|e| e.capitalize}.join
    end
  end
end