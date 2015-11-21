module Trasto::FormHelper
  def self.included(_)
    ActionView::Helpers::FormBuilder.prepend Trasto::FormHelper::Builder

    # TODO add all fields some way
    ActionView::Helpers::Tags::TextField.prepend Trasto::FormHelper::Tags
  end

  def fields_for_locale(builder, &block)
    capture(builder, &block)
  end

  module Builder
    def fields_for_locale(locale, &block)
      @default_options.merge!(trasto_locale: locale)
      @template.fields_for_locale(self, &block)
    end
  end

  module Tags
    def render
      @trasto_locale = @options.delete(:trasto_locale)
      super
    end

    def tag_name(*args)
      if locale = @trasto_locale
        super + "[#{locale}]"
      else
        super
      end
    end
  end
end
