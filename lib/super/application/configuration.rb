module Super
  class Application
    class Configuration
      attr_writer :root_path,
                  :settings_path,
                  :load_paths,
                  :initializers_path

      def root_path
        @root_path ||= ENV['APPLICATION_ROOT']
      end

      def initializers_path
        @initializers_path ||= expand_path('config/initializers')
      end

      def settings_path
        @settings_path ||= expand_path('config/settings.yml')
      end

      def load_paths
        @load_paths ||= []
      end

      private

      def expand_path(path)
        File.expand_path(path, root_path)
      end
    end
  end
end
