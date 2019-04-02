# Hookd

Welcome to hookd, a little application that can be spun up as an endpoint to service git hub webhooks.

## Installation

Add this line to your application's Gemfile:

```bash
$ gem install hookd
```

Start it like so

```bash
$ hookd
```

## Usage

Ensure you fill out some configuration to ensure you process the web hooks the way you want.

TODO - decide how to configure this thing

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Workflow

start the hookd server

      $ rackup -p 3000

start ngrok (make note of the *Forwarding* url)

      $ ngrok http 3000

You can now set the webhook url within GitHub to the Forwarding url returned by above ngrok.

In use is standard ruby, so get the code formatted right with

      $ bundle exec standardrb --fix

### Docker

Build and run a docker continer to serve webhooks

Build:

      $ docker build -t hooker

Debug:

      $ docker run -it hooker sh

Serve:

      $ docker run -it --rm --name=hooker -p 3001:80 hooker

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hookd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hookd project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hookd/blob/master/CODE_OF_CONDUCT.md).