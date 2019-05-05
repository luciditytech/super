require_relative 'http_repository/dsl'

module Super
  module HttpRepository
    def self.included(base)
      base.extend(DSL)
      base.include(InstanceMethods)

      base.class_eval do
        include Component

        inst_accessor :adapter
        interface :where, :find, :create, :update, :destroy
      end
    end

    module InstanceMethods
      def where(query); end

      def find(id); end

      def create(params); end

      def update(id, params); end

      def destroy(id); end

      private

      def settings
        self.class.settings
      end

      def encoder
        settings[:encoder]
      end

      def decoder
        settings[:decoder]
      end

      def encode(entity)
        encoder.call(entity)
      end

      def decode(data)
        decoder.call(data)
      end

      def render_url(url, args = {})
        url.gsub(/{{(.*?)}}/) do |arg|
          key = arg.gsub(/{{|}}/, '').to_sym
          args[key]
        end
      end
    end
  end
end
