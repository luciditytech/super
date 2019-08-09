# frozen_string_literal: true

module Super
  module Struct
    class Attribute
      def initialize(options = {})
        @type = options[:type]
        @decoder = decoder_for(options)
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      def decode(value)
        return unless value
        return value if @type && value.is_a?(@type)
        return instance_exec(value, &@decoder) if @decoder

        raise Super::Errors::DecodeError if @type && !value.is_a?(@type)

        value
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      private

      def decoder_for(options)
        options[:decoder] ||
          codec_decoder_for(options[:codec]) ||
          type_decoder_for(options[:type])
      end

      def codec_decoder_for(codec = nil)
        codec && ->(value) { codec.decode(value) }
      end

      def type_decoder_for(type = nil)
        type &&
          support_decoder_for(type) ||
          native_type_decoder_for(type)
      end

      def support_decoder_for(type)
        codec_class = "Super::Codecs::#{type}Codec"
        return unless Kernel.const_defined?(codec_class)

        codec = Kernel.const_get(codec_class).new
        return unless codec

        ->(value) { codec.decode(value) }
      end

      def native_type_decoder_for(type)
        type.respond_to?(:decode) && ->(value) { type.decode(value) }
      end
    end
  end
end
