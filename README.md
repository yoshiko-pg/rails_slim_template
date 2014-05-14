This is [Rails Application Template](http://guides.rubyonrails.org/rails_application_templates.html).

# rails new
``rails new app_name -m path/to/rails_slim_template.rb``

# alias (zsh)
``alias rnew='rails new$1 -m https://github.com/yoshiko-pg/rails_slim_template/raw/master/rails_slim_template.rb'``
``rnew app_name``

# use gem
* [Slim](http://slim-lang.com/)
* [Bootstrap](http://getbootstrap.com/)
* [Guard](http://guardgem.org/)
* [Spring](https://github.com/rails/spring)
* [RSpec](http://rspec.info/)
* [FactoryGirl](https://github.com/thoughtbot/factory_girl)
* etc...

# replace (delete and create file)
* app/views/layouts/application.html.erb -> application.html.slim
* test/ -> spec/

# run command
* git initial commit, add remote repo
* heroku create, push
* bundle exec guard init rspec
* bundle exec guard init spring
* bundle exec spring binstub rspec
* rails generate rspec:install
* rails generate rails_config:install

# add config
```
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
```

# thanks
http://qiita.com/fakestarbaby/items/01c46a273725d0a48b36  
http://qiita.com/yukimaru@github/items/861ac36cef615d3eb467
