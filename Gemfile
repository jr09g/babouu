source 'https://rubygems.org'


#bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
#use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
#use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
#use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
#bootstrap is the foundation for the styling of babouu
gem 'bootstrap-sass', '~> 3.3.5.1'
#see https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
#use jquery as the JavaScript library
gem 'jquery-rails'
#turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
#build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
#bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
#use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
#devise added to assist in user authentication
gem 'devise', '~> 3.5.1'
#rolify added to help assign roles to users created in devise and check which roles they have
gem 'rolify', '~> 5.0'
#authority to assist in use of roles created by rolify
gem 'authority', '~> 3.1'
#paperclip added to enable attachments to receipts
gem 'paperclip', '~> 4.3.0'
#lazy_high_charts added to implement data charts for spending habits
gem 'lazy_high_charts', '~> 1.5', '>= 1.5.5'
#groupdate added to allow for easy date grouping of models for charting through chartkick
gem 'groupdate', '~> 2.5', '>= 2.5.2'
#active_median takes the average of selected objects
gem 'active_median', '~> 0.1.3'
#aws-sdk provides resources and interface apis for amazon web services
gem 'aws-sdk-rails', '~> 1.0'
#this gem is being bundles specifically for processing with paperclip attachments to S3
gem 'aws-sdk'#, '~> 1.6'
#rubyracer added to assist with asset precompile
gem 'therubyracer', '~> 0.12.2'
#windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  #call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'debugger'
  #access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  #db used in dev environment
  gem 'sqlite3'
end

group :production do
  #db used for production environment on aws server
  gem 'mysql2', '~> 0.3.18'
  #use Unicorn as the app server
  gem 'unicorn'
  gem 'rails_12factor', '0.0.2'
end
