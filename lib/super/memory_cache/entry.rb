module Super
  class MemoryCache
    class Entry
      attr_accessor :key, :payload, :expires_at

      def initialize(key, payload, expires_at:)
        @key = key
        @payload = payload
        @expires_at = expires_at
      end

      def expired?
        return false unless @expires_at

        @expires_at <= Time.now.utc
      end
    end
  end
end
