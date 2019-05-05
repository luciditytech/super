module Super
  module Component
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        include Singleton
        extend SingleForwardable
      end
    end

    module ClassMethods
      def interface(*args)
        return def_delegators(:instance, *args) if args.is_a?(Array)
        return def_delegator(:instance, args) if args.is_a?(Symbol)
      end

      def inst_accessor(method)
        inst_reader(method)
        inst_writer(method)
      end

      def inst_reader(method)
        attr_reader(method)
        def_delegator(:instance, method)
      end

      def inst_writer(method)
        attr_writer(method)
        def_delegator(:instance, "#{method}=")
      end
    end
  end
end
