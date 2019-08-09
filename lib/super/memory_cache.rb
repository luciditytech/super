# frozen_string_literal: true

require 'weakref'

require_relative 'memory_cache/lock'
require_relative 'memory_cache/entry'
require_relative 'memory_cache/node'
require_relative 'memory_cache/linked_list'
require_relative 'memory_cache/maintainer'

module Super
  class MemoryCache
    include Super::Component

    inst_accessor :max_size

    interface :read,
              :write,
              :fetch,
              :expire,
              :flush,
              :prune,
              :size,
              :stored?

    def initialize
      @lock = Lock.new
      @data = LinkedList.new
      @index = {}
      @max_size = 1_000
      @maintainer = Maintainer.bootstrap(self)
    end

    def read(key)
      @lock.synchronize do
        return unless @index.key?(key)

        node = @index[key]
        entry = node.value
        return if entry.expired?

        bump(node)
        Marshal.load(entry.payload)
      end
    end

    def write(key, value, options = {})
      @lock.synchronize do
        stored?(key) ? replace(key, value, options) : store(key, value, options)
      end
    end

    def expire(key)
      @lock.synchronize do
        return unless stored?(key)

        node = index[key]
        remove(node)
      end
    end

    def fetch(key, options = {})
      return read(key) if stored?(key)

      @lock.synchronize(:fetch) do
        stored?(key) ? read(key) : write(key, yield, options)
      end
    end

    def stored?(key)
      @index.key?(key) && !@index[key].value.expired?
    end

    def flush
      @data.flush
      @index = {}
    end

    def size
      @data.size
    end

    def prune
      @lock.synchronize do
        until @data.size <= @max_size
          least_used = @data.first
          remove(least_used)
        end
      end
    end

    private

    def store(key, value, options = {})
      ttl = options.fetch(:ttl, 10 * 60)
      entry = Entry.new(key, Marshal.dump(value), expires_at: generate_expiration(ttl))
      node = Node.new(entry)
      @index[key] = node
      @data.append(node)
      prune
      value
    end

    def replace(key, value, options = {})
      ttl = options.fetch(:ttl, 10 * 60)
      node = @index[key]

      node.value.tap do |entry|
        entry.payload = Marshal.dump(value)
        entry.expires_at = generate_expiration(ttl)
      end

      bump(node)
      value
    end

    def remove(node)
      @data.remove(node)
      @index.delete(node.value.key)
    end

    def bump(node)
      @data.swap(node, @data.last)
    end

    def generate_expiration(ttl)
      Time.now.utc + ttl
    end
  end
end
