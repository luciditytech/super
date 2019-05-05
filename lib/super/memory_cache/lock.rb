module Super
  class MemoryCache
    class Lock
      def initialize
        @locks = {
          global: Mutex.new,
          fetch: Mutex.new
        }
      end

      def synchronize(type = :global)
        current_lock = @locks[type]
        current_lock.lock unless current_lock.owned?
        yield
      ensure
        current_lock.unlock if current_lock.owned? && current_lock.locked?
      end
    end
  end
end
