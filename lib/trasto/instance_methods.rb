module Trasto
  module InstanceMethods

    private

    def read_localized_value(column)
      return nil unless column_value = send("#{column}_i18n")

      locales_for_reading_column(column).each do |locale|
        value = column_value[locale]
        return value if value.present?
      end
      nil
    end

    def write_localized_value(column, value)
      translations = send("#{column}_i18n") || {}
      send("#{column}_i18n=", translations.merge({I18n.locale => value}).with_indifferent_access)
    end

    def locales_for_reading_column(column)
      send("#{column}_i18n").keys.sort_by { |locale|
        case locale.to_sym
        when I18n.locale then "0"
        when I18n.default_locale then "1"
        else locale.to_s
        end
      }
    end

  end
end
