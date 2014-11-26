# Temporarily sets another locale for use with a block.
#
# Portions strongly inspired by Globalize
# https://github.com/globalize/globalize
module Trasto::WithLocale
  def with_locale(locale, &block)
    Trasto.locale = locale

    begin
      result = yield
    ensure
      Trasto.locale = nil
    end

    result
  end

  def with_locales(*list, &block)
    list.flatten.map do |locale|
      with_locale(locale, &block)
    end
  end
end
