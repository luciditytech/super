module Super
  module Heritage
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def inherit(*args)
        heritage.concat(args.to_a).uniq!
      end

      def heritage
        @heritage ||= [:heritage]
      end

      def inherited(subclass)
        heritage.each do |name|
          ivname = "@#{name}"
          ivvalue = instance_variable_get(ivname)
          subclass.instance_variable_set(ivname, ivvalue.clone)
        end

        super
      end
    end
  end
end
