module Super
  module Codecs
    class StringCodec
      def decode(value)
        return unless value

        value.is_a?(String) ? value : String(value)
      rescue TypeError
        raise Super::Errors::DecodeError
      end

      def encode(entity)
        return unless entity
        raise Super::Errors::EncodeError, entity unless entity.is_a?(String)

        entity
      end
    end
  end
end
