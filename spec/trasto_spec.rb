# frozen_string_literal: true

describe ActiveRecord::Base, '.translates' do
  it 'should be available' do
    expect(Post).to respond_to :translates
  end

  it 'should add functionality' do
    expect(Post.new).not_to respond_to :title
    Post.translates :title
    expect(Post.new).to respond_to :title
  end

  it 'should be possible to run more than once' do
    expect(Post.new).not_to respond_to :title, :body
    Post.translates :title
    Post.translates :body
    expect(Post.new).to respond_to :title, :body
  end

  it 'inherits columns from the superclass' do
    Post.translates :title
    SubPost.translates :body
    expect(SubPost.new).to respond_to :title, :body
    expect(Post.new).to respond_to :title
    expect(Post.new).not_to respond_to :body
  end

  it "should leave other columns intact" do
    Post.translates :title
    post = Post.new(constant: "tau")

    expect(post.constant).to eq "tau"
  end
end

describe ActiveRecord::Base, '.translates?' do
  it 'inherits columns from the superclass' do
    Post.translates :title
    SubPost.translates :body

    expect(SubPost.translates?(:title)).to be true
    expect(SubPost.translates?(:body)).to be true
    expect(Post.translates?(:title)).to be true
    expect(Post.translates?(:body)).to be false
  end
end

describe Post, '.translatable_columns' do
  before do
    Post.translates :title
  end

  it 'should list the translatable columns' do
    expect(Post.translatable_columns).to eq([:title])
  end
end

describe Post, '#title' do
  let(:post) { Post.new(title_i18n: { de: 'Hallo', en: 'Hello', sv: 'Hej' }) }

  before do
    Post.translates :title
    I18n.locale = :en
    I18n.default_locale = :de

    post.title_i18n = post.title_i18n.with_indifferent_access
  end

  it 'should give the title in the current locale' do
    expect(post.title).to eq('Hello')
  end

  it 'should fall back to the default locale if locale has entry' do
    I18n.locale = :ru
    expect(post.title).to eq('Hallo')
  end

  it 'should fall back to the default locale if blank' do
    post.title_i18n['en'] = ' '
    expect(post.title).to eq('Hallo')
  end

  it 'should fall back to any other locale if default locale is blank' do
    post.title_i18n['en'] = ' '
    post.title_i18n['de'] = ''
    expect(post.title).to eq('Hej')
  end

  it 'should return nil if all are blank' do
    post.title_i18n['en'] = ' '
    post.title_i18n['de'] = ''
    post.title_i18n['sv'] = nil
    expect(post.title).to be_nil
  end

  it 'should return nil on a blank record' do
    post.title_i18n = nil
    expect(post.title).to be_nil
  end

  it "should generate helper methods" do
    expect(post.title_en).to eq "Hello"
  end

  it "should be able to persist" do
    post.save; post.reload
    expect(post.title_i18n['en']).to eq "Hello"
  end
end

describe Post, '#title=' do
  before do
    Post.translates :title
    I18n.locale = :de
  end

  let(:post) { Post.new }

  it 'should assign in the current locale' do
    post.title = 'Hallo'
    expect(post.title).to eq('Hallo')
    expect(post.title_i18n.with_indifferent_access['de']).to eq('Hallo')
  end
end

describe Post, "dynamic accessors" do
  before do
    Post.translates :title
    I18n.locale = :en
  end

  let(:post) do
    Post.new(title_i18n: {
      en: "Free breakfast",
      fr: "Déjeuner gratuit",
    })
  end

  it "should respond_to title_en" do
    expect(post).to respond_to(:title_en)
  end

  describe "#title_en" do
    it "should return the localized value" do
      expect(post.title_en).to eq "Free breakfast"
      expect(post.title_fr).to eq "Déjeuner gratuit"
      expect(post.title_es).to be nil
    end

    it "should define readers when used" do
      post.title_en
      expect(post.methods.include?(:title_en)).to be true
      expect(post.methods.include?(:title_fr)).to be true
      expect(post.title_en).to eq "Free breakfast"
      expect(post.title_fr).to eq "Déjeuner gratuit"
    end

    it "should not define accessors until used" do
      expect(post.methods.include?(:title_en)).to be false
      expect(post.methods.include?(:title_fr)).to be false
    end

    it "should work with an empty field" do
      post = Post.new
      expect(post.title_en).to be nil
    end
  end

  describe "#title_es=" do
    it "should write the localized value" do
      post.title_es = "Desayuno gratis"
      expect(post.title_i18n["es"]).to eq "Desayuno gratis"
    end

    it "should define writers when used" do
      post.title_es = "Desayuno gratis"
      expect(post.methods.include?(:title_en=)).to be true
      expect(post.methods.include?(:title_es=)).to be true
      expect(post.title_es).to eq "Desayuno gratis"
    end

    it "should not define accessors until used" do
      expect(post.methods.include?(:title_en=)).to be false
      expect(post.methods.include?(:title_es=)).to be false
    end

    it "should work in mass attribute assignment" do
      newpost = Post.new(title_en: "Great job", title_fr: "Beau travail")
      expect(newpost.title_en).to eq "Great job"
      expect(newpost.title_fr).to eq "Beau travail"
    end
  end

  describe "#title_fr=" do
    it "should update existing hstore in AR 4.1" do
      post.save; post.reload

      post.title_fr = "Nouveau"
      post.save; post.reload

      expect(post.title_fr).to eq "Nouveau"
    end
  end
end
