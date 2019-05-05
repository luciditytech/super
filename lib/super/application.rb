require_relative 'application/booter'
require_relative 'application/configuration'

module Super
  class Application
    include Component

    interface :configuration,
              :configure,
              :boot,
              :reload

    inst_accessor :loader

    def configure(*)
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def boot
      Booter.call(self)
    end

    def reload
      loader.reload
    end
  end
end
