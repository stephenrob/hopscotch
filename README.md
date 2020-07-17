# Hopscotch

Hopscotch is a workflow engine built upon RabbitMQ. Taking inspiration from Sneakers, Sidekiq, Hutch and others it combines functionality and ideas from each of these to provide a tool suitable for building an integration platform. Whilst many tools focus on running jobs in the background or consuming messages non combine these into a workflow that would represent the expectation of scheduling a task or process to happen, monitoring its progress and ultimately seeing its completion.

Based upon work @lulibrary to facilitate data ingest and flow between systems hopscotch provides an opinionated yet extensible system to built your next workflow management tool.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hopscotch'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hopscotch

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stephenrob/hopscotch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/stephenrob/hopscotch/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hopscotch project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/stephenrob/hopscotch/blob/master/CODE_OF_CONDUCT.md).
