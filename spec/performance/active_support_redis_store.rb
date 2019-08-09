require 'bundler/setup'
require 'super'
require 'super/struct'
require 'active_support/version'
require 'active_support/cache'
require 'active_support/cache/redis_store'
require 'connection_pool'
require 'securerandom'
require 'benchmark/ips'
require 'benchmark/memory'

class Klass
  include Super::Struct
  attribute :id
  attribute :payload
end

cache = ActiveSupport::Cache::RedisStore.new('redis://localhost:6379/0', pool_size: 8)

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
      cache.fetch(entry.id, expires_in: 600) { entry }
    end
  end
end

Benchmark.memory do |x|
  x.report do
    10_000.times do
      entry = data.sample
      cache.fetch(entry.id, expires_in: 600) { entry }
    end
  end
end
