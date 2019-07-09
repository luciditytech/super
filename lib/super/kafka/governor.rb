module Super
  module Kafka
    class Governor
      include Super::Service

      def call(message, settings, stage)
        return if stage.zero?

        @message = message
        @settings = settings
        @stage = stage
        return unless early?

        wait
      end

      private

      def now
        @now ||= Time.now.utc
      end

      def wait_time
        @wait_time ||= @stage**4 + 15 + (rand(30) * (@stage + 1))
      end

      def early?
        now - @message.create_time < wait_time
      end

      def wait
        Application&.logger&.info("Early message - waiting #{wait_time.to_i} seconds")
        sleep(wait_time)
      end
    end
  end
end
