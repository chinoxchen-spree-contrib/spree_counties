# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "spree_counties"
  s.version     = "3.4.0"
  s.summary     = 'Lets your users pick counties from states list in address\'s step'
  s.description = "Add county model to address"
  s.required_ruby_version = ">= 1.9.3"

  s.author    = "Gonzalo Moreno"
  s.email     = "gmoreno@acid.cl"
  s.homepage  = "http://www.acid.cl"
  s.license   = "MIT"

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"
  s.requirements << "none"

  spree_version = ">= 3.1.0", "< 4.0"
  s.add_dependency "spree_core", spree_version

  s.add_development_dependency "capybara", "~> 2.4"
  s.add_development_dependency "coffee-rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl", "~> 4.4"
  s.add_development_dependency "ffaker"
  s.add_development_dependency "rspec-rails",  "~> 3.1"
  s.add_development_dependency "sass-rails", "~> 5.0.4"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "binding_of_caller"
  s.add_development_dependency "pry"
  s.add_development_dependency "spreadsheet"

  s.add_development_dependency 'spree_backend', spree_version

end
