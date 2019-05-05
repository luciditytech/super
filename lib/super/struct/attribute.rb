module Super
  module Struct
    class Attribute
      def initialize(options)
        return if options[:type].nil?
      end

      def decode(value)
        return value if @decoder.nil?

        @decoder.call(value)
      end
    end
  end
end
