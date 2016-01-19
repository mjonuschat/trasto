module Trasto::FormHelper
  def self.included(_)
    ActionView::Helpers::FormBuilder.prepend Trasto::FormHelper::Builder

    [
      ActionView::Helpers::Tags::TextField,
      ActionView::Helpers::Tags::HiddenField,
      ActionView::Helpers::Tags::TextArea,
      ActionView::Helpers::Tags::Select,
      ActionView::Helpers::Tags::Label,
    ].map do |k|
      k.prepend Trasto::FormHelper::Tags
    end
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

    private

    # For reading
    def value(object)
      return unless object
      return super unless @trasto_locale

      # This method is only necessary for AR4.0
      object.read_with_locale(@method_name, @trasto_locale)
    end

    # For writing
    def tag_name(*args)
      return super unless localized?
      super + "[#{@trasto_locale}]"
    end

    def tag_id(*args)
      return super unless localized?
      super + "_#{@trasto_locale}"
    end

    # Tag is being localized if object might translate column and
    # @trasto_locale is present
    def localized?
      (!object || object.class.translates?(@method_name)) && @trasto_locale
    end
  end
end
