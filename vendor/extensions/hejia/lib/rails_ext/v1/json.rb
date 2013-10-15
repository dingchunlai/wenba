# encoding: utf-8
require 'yajl'

module ActiveSupport
  module JSON #:nodoc:
    self.unquote_hash_key_identifiers = false

    module Encoders #:nodoc:

      define_encoder Object do |object|
        Yajl.dump object.instance_values
      end
      
      dump_self = lambda { |this| Yajl.dump this }
      [TrueClass, FalseClass, NilClass, String, Numeric, Hash].each { |klass| define_encoder klass, &dump_self }

      dump_to_s = lambda { |this| Yajl.dump this.to_s }
      [Symbol, Regexp].each { |klass| define_encoder klass, &dump_to_s }
      
      define_encoder Enumerable do |enumerable|
        "[#{enumerable.map { |value| value.to_json } * ', '}]"
      end

      define_encoder Date do |date|
        date.strftime('%Y-%m-%d').to_json
      end

      define_encoder DateTime do |date_time|
        date_time.strftime('%Y-%m-%d %H:%M:%S').to_json
      end

      define_encoder Time do |time|
        time.strftime('%Y-%m-%d %H:%M:%S').to_json
      end
    end
  end
end
