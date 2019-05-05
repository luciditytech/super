require 'super/application'

class Application < Super::Application
  configure do |app|
    app.load_paths = %w[
      app
      app/services
      app/serializers
      app/routes
      app/models
    ]
  end
end
