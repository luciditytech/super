# Description
**Super** aims to provide the essential building blocks for creating high-performance services. Those services may be APIs, queue workers, stream processors, communicate via message buses, etc. These building blocks may be used separately or together. Furthermore, these building blocks are intended to be simple, easily testable and fast.

# Setup

You can install Super, which will include by default the core toolset.

```
gem 'super'
```

# Usage
## Service
`Super::Service` are simple, single-use service objects that have a default public interface compatible with lambdas - `.call`. Example:

```ruby
class MessageService
  include Super::Service

  def call(message)
    @message = message
    say_stuff
  end

  private

  def say_stuff
    puts @message
  end
end

MessageService.call('Hello World')
"Hello World"
```

# Component
A `Super::Component` is a singleton - and therefore stateful - class that is useful to encapsulate database or HTTP adapters, amongst other things. Example:

```ruby
class RedisService
  include Super::Component

  # Super::Component provides an easy way to define instance-level attributes.
  inst_accessor :adapter

  # you can also easily define the public interface of this component.
  interface :get, :set

  def get(key)
    adapter.get(key)
  end

  def set(key, value)
    adapter.set(key, value)
  end
end

# In an initializer somewhere.
RedisService.adapter = Redis.new

# In your code.
RedisService.set('message', 'Hello World')
```

## Serializer
`Super::Serializer` is designed to be easily testable - you can just provide it with a double for instance - and **fast**. In fact, it can be 10X+ faster than `ActiveModel::Serializer` for most types of objects used in real world applications.

```ruby
class EntrySerializer
  include Super::Serializer

  field :id
  field :timestamp, with: ->(timestamp) { timestamp&.iso8601 }
  field :message, with: MessageSerializer
end

class MessageSerializer
  include Super::Serializer

  field :content

  def content
    entity.content.downcase
  end
end

entry = Entry.new(...)

EntrySerializer.call(entry)
{
  id: '47199a36-38bb-427c-a7ae-ffbb28614b56',
  timestamp: '2019-05-04T18:03:18+02:00',
  message: {
    content: 'test'
  }
}
```

## Application
Check out the test application under `spec/tester` for an example of `Super::Application`. In short, it provides basic mechanisms for providing autoloading, configuration management, interactive consoles, initializers, testing and more!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
