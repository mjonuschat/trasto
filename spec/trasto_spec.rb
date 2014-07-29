require 'spec_helper'
require 'trasto'

describe ActiveRecord::Base, '.translates' do

  it 'should be available' do
    Post.should respond_to :translates
  end

  it 'should add functionality' do
    Post.new.should_not respond_to :title
    Post.translates :title
    Post.new.should respond_to :title
  end

  it 'should be possible to run more than once' do
    Post.new.should_not respond_to :title, :body
    Post.translates :title
    Post.translates :body
    Post.new.should respond_to :title, :body
  end

  it 'inherits columns from the superclass' do
    Post.translates :title
    SubPost.translates :body
    SubPost.new.should respond_to :title, :body
    Post.new.should respond_to :title
    Post.new.should_not respond_to :body
  end

end

describe Post, '.translatable_columns' do

  before do
    Post.translates :title
  end

  it 'should list the translatable columns' do
    Post.translatable_columns.should == [:title]
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
    post.title.should == 'Hello'
  end

  it 'should fall back to the default locale if locale has entry' do
    I18n.locale = :ru
    post.title.should == 'Hallo'
  end

  it 'should fall back to the default locale if blank' do
    post.title_i18n['en'] = ' '
    post.title.should == 'Hallo'
  end

  it 'should fall back to any other locale if default locale is blank' do
    post.title_i18n['en'] = ' '
    post.title_i18n['de'] = ''
    post.title.should == 'Hej'
  end

  it 'should return nil if all are blank' do
    post.title_i18n['en'] = ' '
    post.title_i18n['de'] = ''
    post.title_i18n['sv'] = nil
    post.title.should be_nil
  end

  it 'should return nil on a blank record' do
    post.title_i18n = nil
    post.title.should be_nil
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
    post.title.should == 'Hallo'
    post.title_i18n['de'].should == 'Hallo'
  end

end
