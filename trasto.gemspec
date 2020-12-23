# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trasto/version'

Gem::Specification.new do |gem|
  gem.name          = 'trasto'
  gem.version       = Trasto::VERSION
  gem.authors       = ['Morton Jonuschat']
  gem.email         = ['yabawock@gmail.com']
  gem.description   = 'Translatable columns for Rails 4, directly stored in a Postgres hstore in the model table.'
  gem.summary       = 'Use PostgreSQL hstore to keep column translations in the model table without adding lots of tables/columns.'
  gem.homepage      = 'https://github.com/yabawock/trasto'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ['lib']

  gem.add_dependency 'pg'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec',         '~> 3.0'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'appraisal'
end
