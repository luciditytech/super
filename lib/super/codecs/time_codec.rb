module Super
  module Codecs
    class TimeCodec
      def decode(value)
        return unless value

        value.is_a?(Time) ? value : Time.iso8601(value)
      rescue ArgumentError
        raise Super::Errors::DecodeError, "#{value} as #{value.class}"
      end

      def encode(entity)
        return unless entity
        raise Super::Errors::EncodeError, entity unless entity.is_a?(Time)

        entity.iso8601
      end
    end
  end
end
