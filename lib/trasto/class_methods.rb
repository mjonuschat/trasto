module Trasto
  module ClassMethods

    private

    def translates?(column)
      translatable_columns.include?(column.to_sym)
    end

    def locale_name(locale)
      I18n.t(locale, :scope => :"i18n.languages", :default => locale.to_s.upcase)
    end

  end
end
