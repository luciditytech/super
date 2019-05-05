module Super
  class ResourcePool
    ShuttingDownError = Class.new(StandardError)
    NoAvailableResourceError = Class.new(StandardError)

    def initialize(size: 2)
      @lock = Mutex.new
      @pool = Array.new(size) { yield }
      @online = true
    end

    def each
      @lock.synchronize do
        @pool.each { |resource| yield(resource) }
      end
    end

    def push(resource)
      @lock.synchronize { @pool.push(resource) }
    end

    def pop
      @lock.synchronize { @pool.pop }
    end

    def with(max_tries: 100, wait: 0.1)
      raise ShuttingDownError unless @online

      resource = checkout(max_tries, wait)
      raise NoAvailableResourceError if resource.nil?

      yield(resource)
    ensure
      push(resource) unless resource.nil?
    end

    def shutdown
      @lock.synchronize { @online = false }
      each { |resource| yield(resource) }
    end

    private

    def checkout(max_tries, wait)
      i = 0

      loop do
        resource = pop
        break resource unless resource.nil?

        i += 1
        break if i >= max_tries

        sleep wait
      end
    end
  end
end
