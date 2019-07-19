module Super
  module Component
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        def self.instance
          @instance ||= new
        end

        def self.instance=(value)
          @instance = value
        end
      end
    end

    module ClassMethods
      def inst_delegate(*args)
        [args].flatten.each do |method|
          gen = Forwardable._delegator_method(self, :instance, method, method)
          instance_eval(&gen)
        end
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
          inst_delegate(method)
        end
      end

      def inst_writer(*args)
        args.each do |method|
          attr_writer(method)
          inst_delegate("#{method}=")
        end
      end

      alias interface inst_delegate
    end
  end
end
