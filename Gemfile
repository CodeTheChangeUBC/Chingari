source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.2.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.2.2'
# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.1'
# Use bootstrap-sass
gem 'bootstrap-sass', '3.3.6'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.7.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# These gems are required for the invision prototype
# JS animations
gem 'wow-rails', '0.0.1'
# Carousol animation
gem 'owl_carousel-rails', '0.0.1'
# Font library
gem "font-awesome-rails", '4.7.0.3'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '1.2.5', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Gems required for all envs but production environments
group :development, :test do
  # Use Puma as the app server
  gem 'puma', '3.9.1'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '1.3.13'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '9.0.6', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '2.13'
  gem 'selenium-webdriver', '3.11.0'
end

# Gems required for testing environments
group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

# Gems required for the development environments
group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '3.5.1'
  gem 'listen', '3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

# Gems required for environments that are deployed to the web
group :production do
  # Use Unicorn as the app server
  gem 'unicorn', '5.4.0'
  # Use postgresql as the database for Active Record
  gem 'pg', '0.18'
end
