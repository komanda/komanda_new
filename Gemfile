source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.9'
# gem 'heroku'

gem 'jquery-rails'
gem 'mongoid'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'twitter-bootstrap-rails'
gem 'mongoid_slug', :git => 'https://github.com/digitalplaywright/mongoid-slug'

group :production do
  gem 'thin'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'less-rails'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end