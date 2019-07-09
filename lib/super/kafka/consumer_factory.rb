module Super
  module Kafka
    class ConsumerFactory
      include Super::Service

      def call(settings, adapter)
        @settings = settings
        adapter.consumer(consumer_options)
      end

      private

      def consumer_options
        {
          group_id: @settings.group_id,
          offset_commit_interval: @settings.offset_commit_interval || 1,
          offset_commit_threshold: @settings.offset_commit_threshold || 10
        }.compact
      end
    end
  end
end
