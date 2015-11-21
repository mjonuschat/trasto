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

  # We're subjecting all tags, everywhere to those methods.
  #
  # To be legit, we should probably sub-class the tags classes, but
  # here's to ...efficiency.
  module Tags
    def render
      @trasto_locale = @options.delete(:trasto_locale)
      super
    end

    # For reading
    def value(object)
      return unless object
      return super unless @trasto_locale

      hash = object.send "#{@method_name}_i18n"
      hash[@trasto_locale]
    end

    # For writing
    def tag_name(*args)
      condition =
        (!object || object.class.translates?(@method_name)) &&
        @trasto_locale

      condition ? super + "[#{@trasto_locale}]" : super
    end
  end
end
