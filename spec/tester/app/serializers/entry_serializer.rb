class EntrySerializer
  include Super::Serializer

  root :data

  attribute :id
  attribute :timestamp, with: ->(timestamp) { timestamp&.iso8601 }
  attribute :message, with: MessageSerializer

  postprocess do |result, options|
    result.tap do |r|
      r[:meta] = { page: options[:page] } if options && options[:page]
    end
  end
end
