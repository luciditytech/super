module Super
  module Codecs
    class IntegerCodec
      def decode(value)
        return unless value

        value.is_a?(Integer) ? value : Integer(value)
      rescue ArgumentError, TypeError
        raise Super::Errors::DecodeError, "#{value} as #{value.class}"
      end

      def encode(entity)
        return unless entity
        raise Super::Errors::EncodeError, entity unless entity.is_a?(Integer)

        entity
      end
    end
  end
end
