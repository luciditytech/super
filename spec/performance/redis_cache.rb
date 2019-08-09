require 'bundler/setup'
require 'super'
require 'super/struct'
require 'super/redis_cache'

require 'redis'
require 'connection_pool'
require 'securerandom'

require 'benchmark/ips'
require 'benchmark/memory'

class Klass
  include Super::Struct
  attribute :id
  attribute :payload
end

cache = Super::RedisCache.new.tap do |config|
  config.pool = ConnectionPool.new(size: 8) do
    Redis.new
  end
end

data = Array.new(100_000) do
  Klass.new(
    id: SecureRandom.uuid,
    payload: SecureRandom.hex(1024)
  )
end

Benchmark.ips do |x|
  x.report do
    10_000.times do
      entry = data.sample
      cache.fetch(entry.id, ttl: 600) { entry }
    end
  end
end

Benchmark.memory do |x|
  x.report do
    10_000.times do
      entry = data.sample
      cache.fetch(entry.id, ttl: 600) { entry }
    end
  end
end
