module TwitterOAuth2
  class Client < Rack::OAuth2::Client
    attr_accessor :code_verifier

    def initialize(attributes)
      attributes_with_default = {
        authorization_endpoint: 'https://twitter.com/i/oauth2/authorize',
        token_endpoint: 'https://api.twitter.com/2/oauth2/token'
      }.merge(attributes)
      super attributes_with_default
    end

    def authorization_uri(params = {})
      code_challenge = pkce_session!
      authorization_uri = super({
        code_challenge: code_challenge,
        code_challenge_method: :s256
      }.merge(params))
    end

    def access_token!(*args)
      options = args.extract_options!
      super :body, {
        code_verifier: args.first || self.code_verifier
      }.merge(options)
    end

    private

    def pkce_session!
      self.code_verifier = Base64.urlsafe_encode64(
        SecureRandom.random_bytes(32),
        padding: false
      )
      Base64.urlsafe_encode64(
        OpenSSL::Digest::SHA256.digest(code_verifier),
        padding: false
      )
    end
  end
end
