# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  Dependencies.load_once_paths = []
  Dir["#{RAILS_ROOT}/app_engine/community_engine/engine_plugins/**"].sort.each do |plugin| 
    Dependencies.load_once_paths << "#{plugin}/lib"
  end

  Dir["#{RAILS_ROOT}/vendor/plugins/**"].sort.each do |plugin| 
    Dependencies.load_once_paths << "#{plugin}/lib"
  end

  Dir["#{RAILS_ROOT}/app_engine/**"].sort.each do |plugin| 
    Dependencies.load_once_paths << "#{plugin}"
  end

end

ENV['GEM_PATH'] = '/home/trackforge/gems:/usr/lib/ruby/gems/1.8'

ActionMailer::Base.sendmail_settings = :sendmail

APP_URL = "http://trackforge.heroku.com"
