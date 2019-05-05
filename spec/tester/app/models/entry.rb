class Entry < Dry::Struct
  attribute :id, Types::String
  attribute :timestamp, Types::Time
  attribute :message, Message
end
