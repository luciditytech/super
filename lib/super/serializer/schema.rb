module Super
  module Serializer
    class Schema
      def initialize
        @data = { attributes: {} }
      end

      def [](name)
        @data[name.to_sym]
      end

      def []=(name, options)
        @data[name.to_sym] = options
      end

      def keys
        @data.keys
      end

      def each(&block)
        @data.each(&block)
      end

      def clone
        Schema.new.tap do |s|
          @data[:attributes].each do |k, v|
            s[:attributes][k] = HashmapCloner.call(v)
          end

          s[:root] = @data[:root]&.clone
          s[:postprocess] = @data[:postprocess]&.clone
        end
      end
    end
  end
end
