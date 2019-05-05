module Super
  module Kafka
    class Producer
      include Super::Component

      DEFAULT_SETTINGS = {
        flush_interval: 1,
        timeout_interval: 30,
        max_buffer_size: 10
      }.freeze

      inst_accessor :pool

      interface :configure, :boot, :produce, :flush, :shutdown

      %w[topic flush_interval timeout_interval max_buffer_size].each do |method|
        define_singleton_method(method) do |value|
          settings.send("#{method}=", value)
        end
      end

      def self.settings
        @settings ||= OpenStruct.new(DEFAULT_SETTINGS)
      end

      def configure
        yield(self)
      end

      def boot
        options = {
          execution_interval: settings.flush_interval,
          timeout_interval: settings.timeout_interval
        }

        @flusher = Concurrent::TimerTask.new(options) { flush }
        @flusher.execute
        at_exit { shutdown }
      end

      def produce(message, options = {})
        pool.with do |producer|
          buffer(producer, message, options.merge(topic: settings.topic))
        end
      end

      def flush
        pool.each do |producer|
          next if producer.buffer_size.zero?

          producer.deliver_messages
        end
      end

      def shutdown
        pool.shutdown(&:shutdown)
      end

      private

      attr_reader :flusher

      def settings
        self.class.settings
      end

      def buffer(producer, message, options)
        producer.produce(message, options)
        return if producer.buffer_size <= settings.max_buffer_size

        producer.deliver_messages
      end
    end
  end
end
