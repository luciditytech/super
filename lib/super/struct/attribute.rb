module Super
  module Struct
    class Attribute
      def initialize(options = {})
        @type = options[:type]
        @decoder = decoder_for(options)
      end

      def decode(value)
        return instance_exec(value, &@decoder) if @decoder
        return unless value
        raise Super::Errors::DecodeError if @type && !value.is_a?(@type)

        value
      end

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
