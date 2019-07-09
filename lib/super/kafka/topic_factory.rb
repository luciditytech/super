module Super
  module Kafka
    class TopicFactory
      include Super::Service

      def call(settings, stage)
        base_name = settings.topic
        max_try = settings.retries
        return base_name if stage.zero?
        return base_name + "-try-#{stage}" if stage <= max_try

        base_name + '-dead'
      end
    end
  end
end
