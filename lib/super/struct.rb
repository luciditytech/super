# frozen_string_literal: true

require_relative 'struct/attribute'
require_relative 'struct/schema'
require_relative 'codecs/time_codec'

module Super
  module Struct
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end

    module InstanceMethods
      attr_reader :attributes

      def initialize(params = {})
        @attributes = {}

        self.class.schema.each do |key, _|
          next unless params.key?(key)

          send("#{key}=", params[key])
        end
      end

      def encode
        attributes
      end

      def to_json(options = {})
        JSON.generate(attributes, options)
      end
    end

    module ClassMethods
      def decode(params)
        new(params)
      end

      def attribute(name, options = {})
        schema[name] = options
        attribute = schema[name]
        define_method(name) { @attributes[name] }
        define_method("#{name}=") { |value| @attributes[name] = attribute.decode(value) }
      end

      def schema
        @schema ||= Schema.new
      end
    end
  end
end
