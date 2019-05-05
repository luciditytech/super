require 'weakref'

module Super
  class MemoryCache
    class Maintainer
      def self.bootstrap(cache)
        new(cache).tap(&:boot)
      end

      def initialize(cache)
        @cache = WeakRef.new(cache)
        @task = Concurrent::TimerTask.new { maintain }
        @task.execution_interval = 1
      end

      def boot
        @task.execute
      end

      def maintain
        @cache.prune
      end
    end
  end
end
