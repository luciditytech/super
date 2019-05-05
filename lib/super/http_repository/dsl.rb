module Super
  module HttpRepository
    module DSL
      def settings
        @settings ||= {}
      end

      def base_url(value)
        settings[:base_url] = value
      end

      def encode(value)
        settings[:encoder] = value
      end

      def decode(value)
        settings[:decoder] = value
      end
    end
  end
end
