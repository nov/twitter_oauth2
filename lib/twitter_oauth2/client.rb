module TwitterOAuth2
  class Client < Rack::OAuth2::Client
    def initialize(attributes)
      attributes_with_default = {
        authorization_endpoint: 'https://twitter.com/i/oauth2/authorize',
        token_endpoint: 'https://api.twitter.com/2/oauth2/token'
      }.merge(attributes)
      super attributes_with_default
    end

    def authorization_uri(params = {})
      code_challenge, code_verifier = setup_pkce_session
      authorization_uri = super({
        code_challenge: code_challenge,
        code_challenge_method: :s256
      }.merge(params))
      [authorization_uri, code_verifier]
    end

    def access_token!(code_verifier, options = {})
      super :body, {
        code_verifier: code_verifier
      }.merge(options)
    end

    private

    def setup_pkce_session
      code_verifier = SecureRandom.hex(8)
      code_challenge = Base64.urlsafe_encode64(
        OpenSSL::Digest::SHA256.digest(code_verifier),
        padding: false
      )
      [code_challenge, code_verifier]
    end
  end
end
