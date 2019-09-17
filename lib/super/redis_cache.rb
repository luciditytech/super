module Super
  class RedisCache
    include Super::Component

    inst_accessor :pool
    interface :read, :write, :expire, :fetch, :clear

    # this cache utilizes Redis' LRU / LFU mode capabilities
    # https://redis.io/topics/lru-cache

    def read(key)
      res = pool.with { |conn| conn.get(key) }
      res && decode(res)
    end

    def write(key, value, ttl:)
      res = pool.with { |conn| conn.setex(key, ttl, encode(value)) }
      res == 'OK' ? value : nil
    end

    def expire(key)
      res = pool.with { |conn| conn.del(key) }
      res != 0
    end

    # this properly caches nils
    def fetch(key, ttl:)
      res = check_and_retrieve(key)
      return decode(res[1]) if res[0] && !res[1].nil?

      value = yield
      write(key, value, ttl: ttl)
    end

    def clear
      pool.with(&:flushdb)
    end

    private

    def encode(value)
      Marshal.dump(value)
    end

    def decode(entry)
      Marshal.load(entry)
    end

    def check_and_retrieve(key)
      pool.with do |conn|
        conn.multi do
          conn.exists(key)
          conn.get(key)
        end
      end
    end
  end
end
