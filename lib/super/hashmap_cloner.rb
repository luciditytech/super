module Super
  class HashmapCloner
    include Super::Service

    def call(hash)
      return unless hash

      Hash[hash.map { |k, v| [k.clone, v.clone] }]
    end
  end
end
