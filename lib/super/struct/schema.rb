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

      def clone
        Schema.new.tap do |s|
          each do |name, attribute|
            s[name] = HashmapCloner.call(attribute.options)
          end
        end
      end
    end
  end
end
