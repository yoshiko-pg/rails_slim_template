dir = Dir::pwd

########################################
# Gemfile
########################################
remove_file 'Gemfile'
create_file 'Gemfile' do body = '' end

add_source 'https://rubygems.org'

# default
gem 'rails', '4.1.1'
gem 'sqlite3'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# add
gem 'slim-rails'


########################################
# Bundle install
########################################
run "bundle install"
run "bundle update"


########################################
# Files and Directories
########################################
remove_file 'README.rdoc'
remove_file "public/index.html"

application <<-APPEND_APPLICATION
config.active_record.default_timezone = :local
config.time_zone = 'Tokyo'
config.i18n.default_locale = :ja
config.generators do |g|
  g.template_engine = :slim
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
