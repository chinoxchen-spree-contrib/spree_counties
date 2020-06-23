source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails-controller-testing'

gem 'rubocop', require: false
gem 'rubocop-rspec', require: false

gem 'spree', github: 'spree/spree', branch: '4-1-stable'
gem 'spree_i18n', github: 'spree-contrib/spree_i18n'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise'

gemspec
