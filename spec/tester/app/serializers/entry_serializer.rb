class EntrySerializer
  include Super::Serializer

  root :data

  field :id
  field :timestamp, with: ->(timestamp) { timestamp&.iso8601 }
  field :message, with: MessageSerializer

  postprocess do |result, options|
    result.tap do |r|
      r[:meta] = { page: options[:page] } if options && options[:page]
    end
  end
end
