module Trasto::FormHelper
  def self.included(base)
    ActionView::Helpers::FormBuilder.include Trasto::FormHelper::Builder
  end

  def fields_for_locale(builder, locale, &block)
    capture(builder, &block)
  end

  module Builder
    def fields_for_locale(locale, &block)
      @template.fields_for_locale(self, locale, &block)
    end
  end
end
