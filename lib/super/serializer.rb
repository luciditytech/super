require_relative 'serializer/schema'

module Super
  module Serializer
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
      base.include(Super::Service)
      base.include(Super::Heritage)

      base.class_eval do
        inherit :schema
      end
    end

    module ClassMethods
      def root(name)
        schema[:root] = name
      end

      def attribute(name, options = {})
        schema[:attributes][name] = options
      end

      def postprocess(processor = nil, &block)
        schema[:postprocess] = processor.nil? ? block : processor
      end

      def schema
        @schema ||= Schema.new
      end
    end

    module InstanceMethods
      def call(entity, options = {})
        @entity = entity.is_a?(Hash) ? OpenStruct.new(entity) : entity
        result = serialize_entity
        result = postprocess(result, options)

        format(result)
      end

      private

      attr_reader :entity

      def schema
        self.class.schema
      end

      def postprocess(result, options)
        postprocessor = schema[:postprocess]
        return result if postprocessor.nil?
        return send(postprocessor, result, options) if postprocessor.is_a?(Symbol)

        postprocessor.call(result, options)
      end

      def format(result)
        return result if schema[:root].nil?

        { schema[:root] => result }
      end

      def serialize_entity
        {}.tap do |data|
          schema[:attributes].each do |key, options|
            data[key] = extract_and_encode(key, options)
          end
        end
      end

      def extract_and_encode(key, options)
        return send(key) if options[:with].nil? && respond_to?(key)

        datum = extract(key, options)
        encode(datum, options)
      end

      def extract(key, options)
        extractor = options[:from]
        return entity.send(key) if extractor.nil?
        return send(extractor) if extractor.is_a?(Symbol)

        extractor.call(entity)
      end

      def encode(datum, options)
        encoder = options[:with]
        return datum if encoder.nil?
        return send(encoder, datum) if encoder.is_a?(Symbol)

        encoder.call(datum)
      end
    end
  end
end
