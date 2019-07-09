module Super
  module Codecs
    class FloatCodec
      def decode(value)
        return unless value

        value.is_a?(Float) ? value : Float(value)
      rescue ArgumentError, TypeError
        raise Super::Errors::DecodeError
      end

      def encode(entity)
        return unless entity
        raise Super::Errors::EncodeError unless entity.is_a?(Float)

        entity
      end
    end
  end
end
