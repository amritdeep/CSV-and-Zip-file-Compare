require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KS
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helpers         false
    end
    
    config.before_configuration do
        env_file = File.join(Rails.root, 'config', 'local_env.yml')
        YAML.load(File.open(env_file)).each do |key, value|
            ENV[key.to_s] = value
        end if File.exists?(env_file)
    end
    config.time_zone = 'Central Time (US & Canada)'
    # config.active_job.queue_adapter = :sidekiq
    config.active_record.raise_in_transactional_callbacks = true
  end
end
