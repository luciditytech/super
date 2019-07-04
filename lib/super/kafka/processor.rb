module Super
  module Kafka
    class Processor
      include Super::Component

      inst_accessor :adapter, :task
      inst_reader :state
      interface :run, :start, :stop

      def initialize
        @state = :offline
      end

      def run(task)
        @task = task
        setup_consumer
        start
      end

      def start
        return if @consumer.nil?
        return unless @state == :offline

        Signal.trap('INT') { stop }
        @state = :online
        @consumer.subscribe(@task.settings.topic)

        @consumer.each_message(automatically_mark_as_processed: false) do |message|
          process(message)
        end
      end

      def stop
        @consumer.stop
        @state = :offline
      end

      private

      def setup_consumer
        options = {
          group_id: @task.settings.group_id,
          offset_commit_interval: @task.settings.offset_commit_interval || 1,
          offset_commit_threshold: @task.settings.offset_commit_threshold || 10
        }.compact

        @consumer = @adapter.consumer(options)
      end

      def process(message)
        @task.call(message.value)
        @consumer.mark_message_as_processed(message)
      rescue StandardError => e
        messages = [e.message, *e.backtrace].join("\n")
        logger.error(messages)
      end

      def logger
        Application.logger
      end
    end
  end
end
