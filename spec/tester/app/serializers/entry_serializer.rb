class EntrySerializer
  include Super::Serializer

  field :id
  field :timestamp, with: ->(timestamp) { timestamp&.iso8601 }
  field :message, with: MessageSerializer
end
