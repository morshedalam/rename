# Rename

This plugin allows you to rename your Ruby on Rails 3 application by a a single command.

## Installation

Add this line to your application's Gemfile:

gem 'rename'

## Usage

rails g rename:app_to NewName

That will rename your application name in the following files:
<pre><code>
Rakefile
config.ru
config/routes.rb
config/application.rb
config/environment.rb
config/environments/development.rb
config/environments/test.rb
config/environments/production.rb
initializers/secret_token.rb
initializers/session_store.rb
</code></pre>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
