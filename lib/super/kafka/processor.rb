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

      def run(task, stage: 0)
        @task = task
        @stage = stage
        Signal.trap('INT') { stop }
        start
      end

      def start
        return if consumer.nil?
        return if @state == :online

        @state = :online
        consumer.subscribe(topic)

        consumer.each_message(automatically_mark_as_processed: false) do |message|
          throttle(message)
          process(message)
        end
      end

      def stop
        consumer.stop
        @state = :offline
      end

      private

      def topic
        @topic ||= TopicFactory.call(@task.settings, @stage)
      end

      def next_stage_topic
        @next_stage_topic ||= TopicFactory.call(@task.settings, @stage + 1)
      end

      def consumer
        @consumer ||= ConsumerFactory.call(@task.settings, @adapter)
      end

      def throttle(message)
        Governor.call(message, @task.settings, @stage)
      end

      def process(message)
        ExecuteTask.call(
          task: @task,
          message: message,
          consumer: consumer,
          adapter: @adapter,
          next_topic: next_stage_topic
        )
      end
    end
  end
end
