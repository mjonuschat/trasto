require 'trasto/version'
require 'trasto/translates'
require 'trasto/class_methods'
require 'trasto/instance_methods'
module Trasto
  def self.locale
    defined?(@@locale) && @@locale
  end

  mattr_writer :locale
end
