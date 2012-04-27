source 'http://rubygems.org'

gem "rails", "3.1.0"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'will_paginate'
gem 'jquery-rails'
gem 'sqlite3'
gem 'execjs'
gem 'awesome_print'
gem 'juggernaut'

gem 'therubyracer'

gem 'rails3_acts_as_paranoid'

gem 'rest-client'
gem 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git'

# use local copy of a gem. 
gem "ckeditor", "~> 3.6.0"


gem 'paperclip'

gem "mongrel", '>= 1.2.0.pre2'
gem "RedCloth"

gem 'paper_trail', '~> 2'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
 #gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'rspec-rails'
  gem 'pg'
  gem 'autotest-rails'
end

group :test do
  gem 'guard'
  gem 'guard-rspec'
end

group :production do
  gem 'mysql2'
end
