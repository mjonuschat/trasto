require 'action_view'

describe Trasto::FormHelper do
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  include Trasto::FormHelper

  def protect_against_forgery?; false; end
  attr_accessor :output_buffer

  before do
    @output_buffer = ""
  end

  describe "#fields_for_locale" do
    before do
      concat(form_for(:post, url: "/posts") do |f|
        f.fields_for_locale :de do |g|
          g.text_field :title
        end
      end)
    end

    it "sets the input name to nested locale" do
      expect(output_buffer).to include %{<input name="post[title][de]">}
    end

    it "assigns the existing field value"
    it "works like regular rails fields"
  end
end
