module Super
  module Kafka
    class TaskSettings < OpenStruct
      def retries
        self[:retries] || self.retries = 5
      end
    end
  end
end
