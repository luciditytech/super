require 'config'

module Super
  class Application
    class Booter
      include Service
      extend Forwardable

      def call(app)
        @app = WeakRef.new(app)
        load_settings(settings_path)
        app.loader = setup_loader(load_paths)
        load_initializers(initializers_path)
      end

      private

      attr_reader :app
      def_delegator :app, :configuration

      def_delegators :configuration,
                     :load_paths,
                     :settings_path,
                     :initializers_path

      def load_settings(settings_path)
        Config.load_and_set_settings(settings_path)
      end

      def setup_loader(load_paths)
        Zeitwerk::Loader.new.tap do |l|
          load_paths.each { |path| l.push_dir(path) }
          l.enable_reloading
          l.setup
          l.eager_load
        end
      end

      def load_initializers(initializers_path)
        Dir["#{initializers_path}/**/*.rb"].each do |initializer|
          load(initializer)
        end
      end
    end
  end
end
