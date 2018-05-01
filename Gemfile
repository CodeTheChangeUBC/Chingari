source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'

# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '4.2.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.1'
# Use bootstrap-sass
gem 'bootstrap', '4.0.0'
gem "font-awesome-rails", '4.7.0.4'


# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '5.0.1'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '4.1.9'
# Use TypeScript for easier class declaration
gem 'typescript-rails'
# User the Babel transpiler to support ES6 import and export syntax
gem 'babel-transpiler'
# Use webpacker for dependency management and preprocessing of local JS assets
gem 'webpacker'
# Use foreman to streamline starting both the rails server and the webpack dev server
gem 'foreman'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.7.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.11'

# For secure ENV variables
gem 'figaro', '1.1.1'

# For google oauth
gem 'omniauth-google-oauth2', '0.5.3'
# For fb oauth
gem 'omniauth-facebook', '4.0.0'


# To upload files
gem 'carrierwave', '1.2.2'
# To store files using AWS
gem 'fog-aws'


# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

### Development tools
group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '3.5.1'
  gem 'listen', '3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

### Test Libraries
group :development, :test, :stage do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '9.0.6', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '2.13'
  gem 'selenium-webdriver', '3.11.0'
end

### Database
group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '1.3.13'
end

group :stage, :production do
  # Use postgresql as the database for Active Record
  gem 'pg', '0.18'
end

### Application Server
group :development, :test, :stage do
  # Use Puma as the app server
  gem 'puma', '3.9.1'
end

group :production do
  # Use Unicorn as the app server
  gem 'unicorn', '5.4.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '1.2.5', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
