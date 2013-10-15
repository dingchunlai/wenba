# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'memcache'
memcache_options = {
  :compression => false,
  :debug => false,
  :namespace => "wenba-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}
publish_memcache_options = {
  :ttl => 1,
  :compression => false,
  :debug => false,
  :namespace => "publish-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

memcache_servers = [ 'memcachehost:11211' ]
# memcache_servers = [ '192.168.0.15:11211' ]

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store
  # config.action_controller.session_store = :mem_cache_store
  config.plugin_paths += [File.expand_path('vendor/extensions', RAILS_ROOT)]
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :local

  # Add new inflection rules using the following format
  # (all these examples are active by default):
  # Inflector.inflections do |inflect|
  #   inflect.plural /^(ox)$/i, '\1en'
  #   inflect.singular /^(ox)en/i, '\1'
  #   inflect.irregular 'person', 'people'
  #   inflect.uncountable %w( fish sheep )
  # end

  # See Rails::Configuration for more options

  require File.join(RAILS_ROOT, 'vendor/extensions/hejia/lib/hejia/sys_logger') # 根据实际情况来填写路径信息
  Hejia::SysLogger.app = 'wenba' # 配置项目的名称，方便区分日志的信息是从哪个项目里面出来的
  config.logger = Hejia::SysLogger.instance

end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below
publish_params = *([memcache_servers, publish_memcache_options].flatten)
PUBLISH_CACHE = MemCache.new *publish_params
cache_params = *([memcache_servers, memcache_options].flatten)
CACHE = MemCache.new *cache_params
# ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.merge!({ 'cache' => CACHE })

BASEURL = "/"

KW_TOPIC_INFO = "topic_info_topic_id"
KW_HOT_TOPICS = "hot_topics_limit_days"
KW_TOPICS_LIST = "topics_list/tag_id/tp"

MEMCACHE_PREFIX_KEY = "a"

Engines.disable_code_mixing = true if defined?(Engines)

gem 'hejia_ext_links', '~> 0.7.12'
require 'hejia'
Hejia.configuration.set :promotion_item_default_attributes => %w(title url publish_time entity_created_at).freeze,
  :user_model => 'hejia_user_bbs',
  :staff_model => 'hejia_staff',
  :cache => PUBLISH_CACHE
Hejia.rails_init
# ActionController::Base.session_options[:memcache_server] = 'memcachehost:11211' if %w[development staging].include?(RAILS_ENV)

gem 'will_paginate', '<3.0.pre'
require 'will_paginate'
