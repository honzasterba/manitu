ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  config.action_controller.session_store = :active_record_store
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # config.active_record.default_timezone = :cet
  
  # See Rails::Configuration for more options
end

require 'redcloth/redcloth' if !defined?(RedCloth)

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
    :cz_datetime => "%d.%m.%Y %H:%M",
    :cz_time => "%H:%M",
    :cz_date => "%d.%m.%Y" 
)

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
    :cz_datetime => "%d.%m.%Y %H:%M",
    :cz_datetime_full => "%d.%m.%Y %H:%M:%S",
    :cz_date => "%d.%m.%Y" 
)

ActionMailer::Base.default_charset = "UTF-8"
ActionMailer::Base.delivery_method = :sendmail

