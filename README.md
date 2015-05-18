# Capistrano MySQL-tasks for Bedrock (https://github.com/roots/bedrock)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bedrock-capistrano-mysql', '~> 0.0.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bedrock-capistrano-mysql

## Usage

Require the module in your `Capfile`:

```ruby
require 'bedrock-capistrano-mysql'
```

`bedrock-capistrano-mysql` comes with one task:

* mysql:backup

The `mysql:backup` task will backup your database to your shared-folder. It will keep the five latest backups.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
