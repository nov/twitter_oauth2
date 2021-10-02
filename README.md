# TwitterOauth2

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/twitter_oauth2`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twitter_oauth2'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install twitter_oauth2

## Usage

This gem is built on `rack/oauth2` gem.   
Basically, the usage is same with [the underling gem](https://github.com/nov/rack-oauth2/wiki).

The only difference is that this gem is supporting PKCE as default, since [Twitter **requires** it](https://developer.twitter.com/en/docs/twitter-api/oauth2).

```ruby
require 'twitter_oauth2'

client = TwitterOAuth2::Client.new(
  identifier: '<YOUR-CLIENT-ID>',
  redirect_uri: '<YOUR-CALLBACK-URL>'
)

# NOTE: You can get PKCE code_verifier here.
authorization_uri, code_verifier = client.authorization_uri(
  scope: [
    :'users.read',
    :'tweet.read',
    :'offline.access'
  ],
  state: SecureRandom.hex(16)
)

puts authorization_uri
`open "#{authorization_uri}"`

print 'code: ' and STDOUT.flush
code = gets.chop

# NOTE: Obtaining Access Token & Refresh Token using Authorization Code
client.authorization_code = code
token_response = client.access_token! code_verifier

# NOTE: Refreshing Access Token using Refresh Token
client.refresh_token = token_response.refresh_token
client.access_token!
```

For more usage, read [the underling gem's wiki](https://github.com/nov/rack-oauth2/wiki).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/twitter_oauth2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/twitter_oauth2/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TwitterOauth2 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/twitter_oauth2/blob/master/CODE_OF_CONDUCT.md).
