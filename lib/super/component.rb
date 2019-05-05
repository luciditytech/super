module Super
  module Component
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        extend SingleForwardable

        def self.instance
          @instance ||= new
        end

        def self.instance=(value)
          @instance = value
        end
      end
    end

    module ClassMethods
      def interface(*args)
        return def_delegators(:instance, *args) if args.is_a?(Array)
        return def_delegator(:instance, args) if args.is_a?(Symbol)
      end

      def inst_accessor(*args)
        args.each do |method|
          inst_reader(method)
          inst_writer(method)
        end
      end

      def inst_reader(*args)
        args.each do |method|
          attr_reader(method)
          def_delegator(:instance, method)
        end
      end

      def inst_writer(*args)
        args.each do |method|
          attr_writer(method)
          def_delegator(:instance, "#{method}=")
        end
      end
    end
  end
end
