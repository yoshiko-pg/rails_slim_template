dir = Dir::pwd

########################################
# Gemfile
########################################
remove_file 'Gemfile'
run 'touch Gemfile'

add_source 'https://rubygems.org'

gem 'rails'
gem 'slim-rails'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'faker'
gem 'will_paginate'
gem 'nokogiri'
gem 'spring'

gem_group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spring'
  gem 'factory_girl_rails'
end

gem_group :test do
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  gem 'libnotify' if /linux/ =~ RUBY_PLATFORM
  gem 'growl' if /darwin/ =~ RUBY_PLATFORM
  gem 'rb-notifu' # Uncomment these lines on Windows.
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
    title Railbook
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

@remote_repo = ask("GitHub repo name is ...? [repo_name / no]")
@remote_repo = nil if @remote_repo == 'no'
if @remote_repo
  git :remote => "add origin #@remote_repo"
  git :push => '-u origin master'
end


########################################
# Heroku
########################################
if @remote_repo && yes?('Deploy to heroku?')
  run 'heroku create'
  run "heroku rename #@remote_repo"
  git push: 'heroku master'
end
