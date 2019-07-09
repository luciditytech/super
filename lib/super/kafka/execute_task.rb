module Super
  module Kafka
    class ExecuteTask
      include Super::Service

      def call(task:, message:, consumer:, adapter:, next_topic:)
        @task = task
        @message = message
        @consumer = consumer
        @adapter = adapter
        @next_topic = next_topic

        execute
      end

      private

      def execute
        @task.call(@message.value)
        mark_as_processed
      rescue StandardError => e
        log_error(e.message)
        push_to_next_stage
      end

      def push_to_next_stage
        @adapter.deliver_message(@message.value, topic: @next_topic)
        mark_as_processed
      rescue StandardError => e
        log_error(e)
      end

      def mark_as_processed
        @consumer.mark_message_as_processed(@message)
      end

      def log_error(error)
        Application&.logger&.error(error.message)
      end
    end
  end
end
