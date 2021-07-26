require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module TrainingSystem
  class Application < Rails::Application
    config.load_defaults 6.1
    config.assets.paths << Rails.root.join("vendor", "assets")
  end
end
