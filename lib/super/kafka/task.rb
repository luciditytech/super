module Super
  module Kafka
    module Task
      DSL = %w[topic
               group_id
               offset_commit_interval
               offset_commit_threshold].freeze

      def self.included(base)
        base.extend(ClassMethods)
        base.include(Service)
      end

      module ClassMethods
        DSL.each do |method|
          define_method(method) do |value|
            settings.send("#{method}=", value)
          end
        end

        def settings
          @settings ||= OpenStruct.new
        end
      end
    end
  end
end
