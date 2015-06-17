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

You need to add two lines to your local .env file:

```
VAGRANT_PATH=~/path-to-bedrock-ansible
VAGRANT_SITE_NAME=site-name
```

You also need to add the line VAGRANT_PATH to your local .env file, pointing to your local `bedrock-ansible` project. You also to keep an .env-file for each environment. Meaning you need .env for your local environment, and one for each additional environment you want to work with – i.e. .env.staging, .env.production and so on...

## Usage

Require the module in your `Capfile`:

```ruby
require 'bedrock-capistrano-mysql'
```

`bedrock-capistrano-mysql` comes with five tasks:

* mysql:backup
* mysql:download
* mysql:change_url
* mysql:import

The `mysql:backup` task will backup your database to your shared-folder. It will keep the five latest backups. `mysql:download` downloads the file to your local project folder. `mysql:change_url` does a search and replace for the domain. `mysql:import` imports it into your dev database and `mysql:sync` does everything, in this order.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
