# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trasto/version'

Gem::Specification.new do |gem|
  gem.name          = "trasto"
  gem.version       = Trasto::VERSION
  gem.authors       = ["Morton Jonuschat"]
  gem.email         = ["yabawock@gmail.com"]
  gem.description   = %q{Translatable columns for Rails 3, directly stored in a postgres hstore in the model table.}
  gem.summary       = %q{Make use of PostgreSQL hstore extension to store all column translations directly in the model table without adding tons of tables or columns}
  gem.homepage      = "https://github.com/yabawock/trasto"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency              "pg",                           "~> 0.10"
  gem.add_dependency              "activerecord-postgres-hstore", ">= 0.4.0"

  gem.add_development_dependency  "rake",                         "~> 0.9.2"
  gem.add_development_dependency  "rspec",                        "~> 2.11.0"
  gem.add_development_dependency  "pry"
  gem.add_development_dependency  "appraisal"
end
