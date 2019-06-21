require_relative 'application/booter'
require_relative 'application/configuration'

module Super
  class Application
    include Component

    inst_accessor :loader

    interface :configuration,
              :configure,
              :boot,
              :reload,
              :logger

    def configure(*)
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def boot
      Booter.call(self)
    end

    def logger
      configuration.logger
    end

    def reload
      loader.reload
    end
  end
end
