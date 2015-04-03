describe Trasto::FormHelper do
  describe "#fields_for_locale" do
    before do
      form_for @post do |f|
        fields_for_locale :de do |g|
          concat g.text_field :title
        end
      end
    end

    it "sets the input name to nested locale" do
      expect(output).to eq "<input name=\"post[title][de]\">"
    end

    it "assigns the existing field value"
    it "works like regular rails fields"
  end
end
