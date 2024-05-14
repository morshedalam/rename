# Rename

This gem allows you to rename your Rails application by using a single command.

Tested up to Ruby 3.2.2 and Rails 7.0.8

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rename'
```

## Usage

```
rails g rename:into New-Name
```

## Applied

```
Search and replace exact module name to...
  Gemfile
  Gemfile.lock
  README.md
  Rakefile
  config.ru
  config/application.rb
  config/boot.rb
  config/environment.rb
  config/environments/development.rb
  config/environments/production.rb
  config/environments/test.rb
  config/importmap.rb
  config/initializers/assets.rb
  config/initializers/content_security_policy.rb
  config/initializers/filter_parameter_logging.rb
  config/initializers/inflections.rb
  config/initializers/permissions_policy.rb
  config/puma.rb
  config/routes.rb
  app/views/layouts/application.html.erb
  app/views/layouts/application.html.haml
  app/views/layouts/application.html.slim
  README.md
  README.markdown
  README.mdown
  README.mkdn
Search and replace underscore seperated module name to...
  config/initializers/session_store.rb
  config/database.yml
  config/cable.yml
  config/environments/production.rb
  package.json
Removing references...
  .idea
Renaming directory...
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
