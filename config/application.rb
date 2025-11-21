require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# For some reason I need to require this explicitly before I use it, even though I have the gem in the Gemfile.
require 'capitalize_names'

module Ratemyskipper
	class Application < Rails::Application
		# Initialize configuration defaults for originally generated Rails version.
		config.load_defaults 7.0

		# Configuration for the application, engines, and railties goes here.
		#
		# These settings can be overridden in specific environments using the files
		# in config/environments, which are processed later.
		#
		# config.time_zone = "Central Time (US & Canada)"
		# config.eager_load_paths << Rails.root.join("extras")
		config.active_job.queue_adapter = :sidekiq

		# Serve assets compressed for faster page loadtimes.
		# Make sure Rack::Deflater it runs after ActionDispatch::Static, if it's present.
		config.middleware.insert_before ActionDispatch::Executor, Rack::Deflater
	end
end
