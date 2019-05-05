class MessageSerializer
  include Super::Serializer

  field :content

  def content
    entity.content.downcase
  end
end
