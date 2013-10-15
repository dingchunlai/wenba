# encoding: utf-8
Dir[File.expand_path("../../../lib/rails_ext/v#{Rails::VERSION::MAJOR}/*.rb", __FILE__)].sort!.each { |ext| load ext } unless defined?(Hejia::HejiaEngine)
