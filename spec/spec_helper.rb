# frozen_string_literal: true

RSpec.configure do |config|
  # Clear class state before each spec.
  config.before(:each) do
    Object.send(:remove_const, 'Post')
    Object.send(:remove_const, 'SubPost')
    load 'app/post.rb'
  end

  # If you really need a clean run (for eg. Travis)
  # config.after :suite do
  #   ActiveRecord::Base.connection.execute <<-eosql
  #     DROP TABLE posts;
  #     DROP EXTENSION IF EXISTS hstore CASCADE;
  #   eosql
  # end
end

# Test against real ActiveRecord models.
# Very much based on the test setup in
# https://github.com/iain/translatable_columns/

require 'active_record'
require 'silent_stream'
require 'trasto'

require 'app/post'
require 'pry'

ActiveRecord::Base.establish_connection adapter: 'postgresql', database: 'trasto-test'

I18n.enforce_available_locales = false

Class.new.include(SilentStream).silence_stream($stdout) do
  ActiveRecord::Schema.define(version: 0) do
    enable_extension "hstore"

    create_table :posts, force: true do |t|
      t.hstore :title_i18n
      t.hstore :body_i18n
      t.string :constant
    end
  end
end

I18n.load_path << 'spec/app/de.yml'
