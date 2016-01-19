require 'action_view'
require 'rspec-html-matchers'

describe Trasto::FormHelper do
  include RSpecHtmlMatchers

  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::CaptureHelper
  include Trasto::FormHelper

  module MockController
    def protect_against_forgery?; false; end
  end
  include MockController

  def mock_form_for(record, options = {}, &block)
    options.merge!(as: :post, url: "/posts")
    form_for(record, options, &block)
  end

  attr_accessor :output_buffer

  before do
    Post.translates :title
    I18n.locale = :en
    @output_buffer = ""
  end

  let(:marmot){ {en: "A marmot", fr: "Une marmotte"} }
  let(:post) do
    Post.new(
      title_i18n: marmot,
      slug: "marmot"
    )
  end

  describe "#fields_for_locale" do
    it "sets the input name to nested locale" do
      # should also work with :post
      concat(mock_form_for(post) do |f|
        f.fields_for_locale :de do |g|
          concat g.text_field :title
          concat g.text_field :slug
        end
      end)

      expect(output_buffer).to have_tag("input",
                                        with: {name: "post[title][de]"})
      expect(output_buffer).to have_tag("input",
                                        with: {name: "post[slug]"})
    end

    it "assigns the existing field value" do
      concat(mock_form_for(post) do |f|
        f.fields_for_locale :fr do |g|
          concat g.text_field :title
          concat g.text_field :slug
        end
      end)

      expect(output_buffer).to have_tag("input",
                                        with: {value: marmot[:fr]})
      expect(output_buffer).to have_tag("input",
                                        with: {value: post.slug})
    end

    it "works with select" do
      concat(mock_form_for(post) do |f|
        f.fields_for_locale :fr do |g|
          concat g.select :title, {"Un animal" => "animal", "Un mammifère" => "mammifere"}
        end
      end)

      expect(output_buffer).to have_tag("select", with: {name: "post[title][fr]"})
    end
  end

  describe "#text_field" do
    it "accepts trasto_locale option" do
      concat text_field(:post, :title, trasto_locale: 'fr')
      expect(output_buffer).to have_tag("input",
                                        with: {name: "post[title][fr]"})
    end
  end

  describe "without trasto" do
    it "works" do
      concat(mock_form_for(post) do |f|
        f.text_field :slug
      end)

      expect(output_buffer).to have_tag("input",
                                        with: {name: "post[slug]"})
    end
  end
end
