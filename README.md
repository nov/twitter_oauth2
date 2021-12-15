# TwitterOAuth2

Twitter OAuth2 Client Library in Ruby.

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
  identifier:   '<YOUR-CLIENT-ID>',
  secret:       '<YOUR-CLIENT-SECRET>',
  redirect_uri: '<YOUR-CALLBACK-URL>'
)

authorization_uri = client.authorization_uri(
  scope: [
    :'users.read',
    :'tweet.read',
    :'offline.access'
  ]
)

# NOTE:
#  When `TwitterOAuth2::Client#authorization_uri` is called,
#  PKCE `code_verifier` and `state` are automatically generated.
#  You can get it here.

code_verifier = client.code_verifier
state = client.state

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

If you want to get App-only Bearer Token (via `grant_type=client_credentials`), you need some tweaks as below.

```ruby
require 'twitter_oauth2'

client = TwitterOAuth2::Client.new(
  # NOTE: not OAuth 2.0 Client ID, but OAuth 1.0 Consumer Key (a.k.a API Key)
  identifier:   '<YOUR-CONSUMER-KEY>',
  # NOTE: not OAuth 2.0 Client Secret, but OAuth 1.0 Consumer Secret (a.k.a API Key Secret)
  secret:       '<YOUR-CONSUMER-SECRET>'
  # NOTE: Twitter has Client Credentials Grant specific token endpoint.
  token_endpoint: '/oauth2/token',
)

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

Everyone interacting in the TwitterOAuth2 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/twitter_oauth2/blob/master/CODE_OF_CONDUCT.md).
