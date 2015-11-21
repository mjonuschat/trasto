require 'action_view'
require 'rspec-html-matchers'

describe Trasto::FormHelper do
  include RSpecHtmlMatchers

  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  include Trasto::FormHelper

  module MockController
    def protect_against_forgery?; false; end
  end
  include MockController

  attr_accessor :output_buffer

  before do
    @output_buffer = ""
  end

  describe "#fields_for_locale" do
    before do
      concat(form_for(:post, url: "/posts") do |f|
        f.fields_for_locale :de do |g|
          # binding.pry
          g.text_field :title
        end
      end)
    end

    it "sets the input name to nested locale" do
      expect(output_buffer).to have_tag("input",
                                        with: {name: "post[title][de]"})
    end

    it "assigns the existing field value"
    it "works like regular rails fields"
  end

  describe "field with locale option" do
    it do
      concat text_field(:post, :title, trasto_locale: 'fr')
      expect(output_buffer).to have_tag("input",
                                        with: {name: "post[title][fr]"})
    end
  end

  # f.fields_for_locale
  # Builder#fields_for_locale
  # LocaleBuilder/g g.text_field
end
