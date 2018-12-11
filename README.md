# Dealersocket::Client

A client library written in plain old Ruby to facilitate working with the Dealersocket API from within our projects. The original thought was to set this up in such a way as to enable any company to use the code, but for now there are still lots of hard coded variables that will only work for T2's projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dealersocket-client'
```

And then execute:

    $ bundle

## Usage

For initial setup, you'll need to either configure the client via an initializer:
```ruby
Dealersocket::Client.configure do |config|
  config.public_key = <PUBLIC_KEY_HERE>
  config.secret_key = <SECRET_KEY_HERE>
  config.username = <USERNAME_HERE>
  config.password = <PASSWORD HERE>
end
```
OR

You'll set the the following environment variables:
- DEALERSOCKET_PUBLIC_KEY
- DEALERSOCKET_SECRET_KEY
- DEALERSOCKET_USERNAME (only used for `Event.create`)
- DEALERSOCKET_PASSWORD (only used for `Event.create`)

Usage is pretty straightforward, as the client models are setup in a way to act like ActiveRecord. I've taken the hashes returned from Dealersocket and made a thin wrapper around them so that objects can be interacted with very similarly to ActiveRecord objects.

```ruby
customer = Dealersocket::Client::Customer.find(id: 12342, dealer_number_id: '372_32')
customer.id = 12342
customer.update(family_name: 'Lopez')
```

Most errors should be handled within the implementation code. This gem has basic error handling and normally throws errors after formatting them a little.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dealersocket-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Dealersocket::Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dealersocket-client/blob/master/CODE_OF_CONDUCT.md).
