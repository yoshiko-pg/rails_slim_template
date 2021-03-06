dir = Dir::pwd

########################################
# Gemfile
########################################
remove_file 'Gemfile'
create_file 'Gemfile' do body = '' end

add_source 'https://rubygems.org'

gem 'rails'
gem 'slim-rails'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'faker'
gem 'will_paginate'
gem 'nokogiri'
gem 'spring'
gem 'dotenv-rails'

gem_group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spring'
  gem 'factory_girl_rails'
  gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
  gem 'wdm', platforms: [:mingw, :mswin, :x64_mingw]
end

gem_group :test do
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  gem 'libnotify' if /linux/ =~ RUBY_PLATFORM
  gem 'growl' if /darwin/ =~ RUBY_PLATFORM
  gem 'rb-notifu', platforms: [:mingw, :mswin, :x64_mingw]
end

gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'

gem_group :production do
  gem 'pg'
  gem 'rails_12factor'
end


########################################
# Bundle install
########################################
run "bundle install"
run "bundle update"
run "bundle install"


########################################
# Guard
########################################
run "bundle exec guard init rspec"


########################################
# Generators
########################################
generate 'rspec:install'
generate 'rails_config:install'


########################################
# Spring
########################################
run 'bundle exec spring binstub rspec'
run "bundle exec guard init spring"


########################################
# Rspec
########################################
rspec = File.open("#{dir}/.rspec").read
remove_file '.rspec'
create_file '.rspec' do
  body = "#{rspec}--drb"
end

########################################
# Files and Directories
########################################
remove_dir 'test'
remove_file 'README.rdoc'
remove_file "public/index.html"

application <<-APPEND_APPLICATION
config.active_record.default_timezone = :local
config.time_zone = 'Tokyo'
config.i18n.default_locale = :ja
config.generators do |g|
  g.template_engine = :slim
  g.test_framework  = :rspec
  g.integration_tool  = :rspec
  g.fixture_replacement :factory_girl
  g.stylesheets = false
  g.javascripts = false
  g.helper      = false
end
APPEND_APPLICATION

remove_file 'app/views/layouts/application.html.erb'
create_file 'app/views/layouts/application.html.slim' do
  body = <<EOS
doctype 5
html lang="ja"
  head
    meta charset="UTF-8"
    meta name="viewport" content="width=device-width, initial-scale=1.0"
    title TmpTitle
    = stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true
    = javascript_include_tag "application", "data-turbolinks-track" => true
    = csrf_meta_tags
  body
    = yield
EOS
end

remove_file '.gitignore'
create_file '.gitignore' do
  body = <<EOS
/.bundle
/db/*.sqlite3
/log/*.log
/tmp
.DS_Store
/public/assets*
/config/database.yml
newrelic.yml
.foreman
.env
doc/
*.swp
*~
.project
.idea
.secret
/*.iml
EOS
end

guard = File.open("#{dir}/Guardfile").read
remove_file 'Guardfile'
create_file 'Guardfile' do
  body = "require 'active_support/inflector'

  #{guard}"
end


########################################
# Git
########################################
git :init
git :add => '.'
git :commit => '-am "Initial commit"'

if yes?('Exist remote repository? [yes/no]')
  @remote_repo = ask("remote repository url is")
  git :remote => "add origin #@remote_repo"
  git :push => '-u origin master'
end


########################################
# Heroku
########################################
if yes?('Deploy to heroku? [yes/no]')
  @heroku_name = ask("heroku app name is")
  run 'heroku create'
  run "heroku rename #@heroku_name"
  git push: 'heroku master'
end
