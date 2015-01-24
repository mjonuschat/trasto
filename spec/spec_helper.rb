RSpec.configure do |config|
  # Clear class state before each spec.
  config.before(:each) do
    Object.send(:remove_const, 'Post')
    Object.send(:remove_const, 'SubPost')
    load 'app/post.rb'
  end
end

# Test against real ActiveRecord models.
# Very much based on the test setup in
# https://github.com/iain/translatable_columns/

require 'active_record'

require 'app/post.rb'
require 'pry'

ActiveRecord::Base.establish_connection adapter: 'postgresql', database: 'trasto-test'

I18n.enforce_available_locales ||= false

silence_stream(STDOUT) do
  ActiveRecord::Schema.define(version: 0) do
    execute 'CREATE EXTENSION IF NOT EXISTS hstore'

    create_table :posts, force: true do |t|
      t.hstore :title_i18n
      t.hstore :body_i18n
    end
  end
end

I18n.load_path << 'spec/app/de.yml'
