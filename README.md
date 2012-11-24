# Rename

This Gem allows you to rename a Rails3 application by using a single command.


## Installation

Add this line to your application's Gemfile:

<pre><code>gem 'rename'</code></pre>


## Usage

<pre><code>rails g rename:app_to NewName
rails g rename:app_to "New-Name"
</code></pre>

That will rename your application's name in the following files:
<pre><code>Rakefile
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
