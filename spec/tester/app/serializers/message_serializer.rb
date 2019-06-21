class MessageSerializer
  include Super::Serializer

  attribute :content

  def content
    entity.content.downcase
  end
end
