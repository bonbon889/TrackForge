# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  Dependencies.load_once_paths = []
  Dir["#{RAILS_ROOT}/app_engine/community_engine/engine_plugins/**"].sort.each do |plugin| 
    Dependencies.load_once_paths << "#{plugin}/lib"
  end
  Dir["#{RAILS_ROOT}/vendor/plugins/**"].sort.each do |plugin| 
    Dependencies.load_once_paths << "#{plugin}/lib"
  end
  #Dependencies.load_once_paths << "#{RAILS_ROOT}/vendor/plugins/engines/lib"
  #Dependencies.load_once_paths << "#{RAILS_ROOT}/vendor/plugins/bundle_fu/lib"
  
  #puts Dependencies.load_once_paths.inspect
end

ActionMailer::Base.sendmail_settings = :sendmail

APP_URL = "http://localhost:3000"