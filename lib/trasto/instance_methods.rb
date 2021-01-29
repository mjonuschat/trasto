# frozen_string_literal: true

module Trasto
  module InstanceMethods
    def self.included(base)
      prepend HstoreUpdatePatch if ActiveRecord::VERSION::STRING < "4.2.0"
      super
    end

    def method_missing(method, *args, &block)
      # Return super only if above can respond without us.
      # If we call super and above cannot respond without us,
      # infinite recursion occurs.
      return super if respond_to?(method) && !respond_to_missing?(method)

      if match = match_translate_method(method)
        # We define accessors after getting the value in the hopes of
        # capturing a new locale that would be useful.
        return access_translated_value(*match, args).tap do
          define_translation_accessors!
        end
      end

      super
    end

    def respond_to_missing?(method, include_privates = false)
      !!match_translate_method(method)
    end

    def define_translation_accessors!
      self.class.translatable_columns.each do |column|
        return unless column_value = send("#{column}_i18n")

        column_value.keys.each do |locale|
          define_singleton_method "#{column}_#{locale}" do
            read_translated_value(column, locale)
          end

          define_singleton_method "#{column}_#{locale}=" do |value|
            write_translated_value(column, locale, value)
          end
        end
      end
    end

    private

    def access_translated_value(column, locale, write_mode, args = [])
      if write_mode
        write_translated_value(column, locale, args[0])
      else
        read_translated_value(column, locale)
      end
    end

    # Finds a suitable translation for column
    def read_localized_value(column)
      return nil unless (column_value = send("#{column}_i18n"))
      column_value = column_value.with_indifferent_access # Rails < 4.1

      locales_for_reading_column(column).each do |locale|
        value = column_value[locale]
        return value if value.present?
      end

      nil
    end

    # Reads column value in specified locale
    def read_translated_value(column, locale)
      return unless column_value = send("#{column}_i18n")
      column_value = column_value.with_indifferent_access
      column_value[locale]
    end

    def write_localized_value(column, value)
      write_translated_value(column, I18n.locale, value)
    end

    def write_translated_value(column, locale, value)
      translations = send("#{column}_i18n") || {}
      translations.merge!(locale => value).with_indifferent_access
      send("#{column}_i18n=", translations)
    end

    def locales_for_reading_column(column)
      send("#{column}_i18n").keys.sort_by do |locale|
        case locale.to_sym
        when I18n.locale then '0'
        when I18n.default_locale then '1'
        else locale.to_s
        end
      end
    end

    # Returns an array with column, name and maybe equal if match, else
    # returns nil.
    #
    # [column, locale, "=" or nil]
    def match_translate_method(method)
      ary = method.to_s.scan(/^(.*)_([a-z]{2})(=)?$/).flatten
      return nil if ary.empty?

      ary if self.class.translates?(ary[0])
    end

    # Patches an ActiveRecord bug that wouldn't update the hstore when
    # changed. Affects 4.0, 4.1.
    #
    # See https://github.com/rails/rails/issues/6127
    module HstoreUpdatePatch
      def write_translated_value(column, locale, value)
        send("#{column}_i18n_will_change!")
        super
      end
    end
  end
end
