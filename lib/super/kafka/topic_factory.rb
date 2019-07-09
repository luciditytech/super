module Super
  module Kafka
    class TopicFactory
      include Super::Service

      def call(settings, stage)
        default_topic = settings.topic
        max_try = settings.retries
        return default_topic if stage.zero?
        return default_topic + "-try-#{stage}" if stage <= max_try

        default_topic + '-dlq'
      end
    end
  end
end
