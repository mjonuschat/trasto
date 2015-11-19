module Trasto::FormHelper
  def fields_for_locale(locale, &block)
    yield(self)
  end
end
