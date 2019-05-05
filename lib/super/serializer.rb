module Super
  module Serializer
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)

      base.class_eval do
        include Service
      end
    end

    module ClassMethods
      def field(name, options = {})
        schema[name] = options
      end

      def schema
        @schema ||= {}
      end
    end

    module InstanceMethods
      def call(entity)
        @entity = entity

        {}.tap do |data|
          schema.each do |key, options|
            data[key] = extract_and_encode(key, options)
          end
        end
      end

      private

      attr_reader :entity

      def schema
        self.class.schema
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
