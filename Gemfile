source 'https://rubygems.org'
ruby '2.2.1'

gem 'rails', '4.2.5.2'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'paperclip'
gem 'aws-sdk', '< 2.0'
gem 'rubyzip'
gem 'zip-zip' 
gem 'devise', '3.4.1'
gem 'smarter_csv'

group :development do
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'web-console', '~> 2.0'
end

group :staging, :production do 
	gem "puma"
end

group :development, :test do
	gem 'capistrano',         require: false
	gem 'simplecov', 		  require: false
	gem 'capistrano-rvm',     require: false
	gem 'capistrano-rails',   require: false
	gem 'capistrano-bundler', require: false
	gem 'with_advisory_lock'
	gem 'byebug'
	gem 'pry'
	gem 'pry-rails'
	gem 'pry-byebug'
	gem 'webmock', require: false
	gem 'faker'
	gem 'rspec-rails'
	gem 'factory_girl_rails'
	gem 'database_cleaner'
	gem 'shoulda-matchers', require: false
	gem 'shoulda-callback-matchers'
end
