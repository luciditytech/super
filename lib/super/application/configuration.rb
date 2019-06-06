require 'ostruct'

module Super
  class Application
    class Configuration < OpenStruct
      def root_path
        self[:root_path] ||= ENV['APPLICATION_ROOT']
      end

      def initializers_path
        self[:initializers_path] ||= expand_path('config/initializers')
      end

      def settings_path
        self[:settings_path] ||= expand_path('config/settings.yml')
      end

      def load_paths
        self[:load_paths] ||= []
      end

      def logger
        self[:logger] ||= Logger.new(STDOUT)
      end

      private

      def expand_path(path)
        File.expand_path(path, root_path)
      end
    end
  end
end
