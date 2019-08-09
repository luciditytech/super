# frozen_string_literal: true

module Super
  module Struct
    class Schema
      def initialize
        @attributes = {}
      end

      def [](name)
        @attributes[name.to_sym]
      end

      def []=(name, options)
        @attributes[name.to_sym] = Attribute.new(options)
      end

      def each(&block)
        @attributes.each(&block)
      end

      def keys
        @attributes.keys
      end
    end
  end
end
