require 'spec_helper'
require 'trasto'

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
    expect(post.title_i18n['de']).to eq('Hallo')
  end
end
