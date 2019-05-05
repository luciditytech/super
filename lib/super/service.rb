module Super
  module Service
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def call(*args)
        new.call(*args)
      end
    end
  end
end
