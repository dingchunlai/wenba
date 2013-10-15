# encoding: utf-8
ActiveRecord::Base.class_eval do
  class << self; self end.send :alias_method, :named_scope, :has_finder if respond_to?(:has_finder) && !respond_to?(:named_scope)
end

