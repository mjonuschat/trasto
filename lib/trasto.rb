require 'trasto/version'
require 'trasto/translates'
require 'trasto/class_methods'
require 'trasto/instance_methods'
require 'trasto/with_locale'

module Trasto
  extend WithLocale

  def self.locale
    defined?(@@locale) && @@locale
  end

  mattr_writer :locale
end
