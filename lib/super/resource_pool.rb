module Super
  class ResourcePool
    ShuttingDownError = Class.new(StandardError)
    NoAvailableResourceError = Class.new(StandardError)

    attr_reader :pool

    def initialize(size: 2)
      @lock = Mutex.new
      @cv = ConditionVariable.new
      @pool = Array.new(size) { yield }
      @online = true
    end

    def each
      @lock.synchronize do
        @pool.each { |resource| yield(resource) }
      end
    end

    def push(resource)
      @lock.synchronize { @pool.push(resource) && @cv.broadcast }
    end

    def pop(timeout: 1, max_tries: 1)
      @lock.synchronize { @pool.pop || checkout(now + timeout, max_tries) }
    end

    def with(timeout: 1, max_tries: 100)
      @lock.synchronize { raise ShuttingDownError unless @online }

      resource = pop(timeout: timeout, max_tries: max_tries)
      raise NoAvailableResourceError unless resource

      yield(resource)
    ensure
      push(resource) unless resource.nil?
    end

    def shutdown
      @lock.synchronize { @online = false }
      each { |resource| yield(resource) }
    end

    private

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def checkout(deadline, max_tries)
      tries = 0

      loop do
        resource = @pool.pop
        return resource if resource

        tries += 1
        return if tries >= max_tries

        wait_time = deadline - now
        return if wait_time <= 0

        @cv.wait(@lock, wait_time)
      end
    end
  end
end
