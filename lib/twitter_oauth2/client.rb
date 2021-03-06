module TwitterOAuth2
  class Client < Rack::OAuth2::Client
    attr_accessor :code_verifier, :code_challenge, :code_challenge_method, :state

    def initialize(attributes)
      attributes_with_default = {
        host: 'api.twitter.com',
        authorization_endpoint: 'https://twitter.com/i/oauth2/authorize',
        token_endpoint: '/2/oauth2/token'
      }.merge(attributes)
      super attributes_with_default
    end

    def authorization_uri(params = {})
      authorization_session!
      super({
        code_challenge: code_challenge,
        code_challenge_method: code_challenge_method,
        state: state
      }.merge(params))
    end

    def access_token!(*args)
      options = args.extract_options!
      super({
        # NOTE:
        #  For some reason, Twitter requires client_id duplication both in body & header for confidentail clients.
        #  Follow such behaviour for now.
        #  Hopefully, I can remove this line in near future.
        client_id: identifier,

        code_verifier: args.first || self.code_verifier
      }.merge(options))
    end

    private

    def authorization_session!
      self.state = Base64.urlsafe_encode64(
        SecureRandom.random_bytes(16),
        padding: false
      )
      self.code_verifier = Base64.urlsafe_encode64(
        SecureRandom.random_bytes(32),
        padding: false
      )
      self.code_challenge = Base64.urlsafe_encode64(
        OpenSSL::Digest::SHA256.digest(code_verifier),
        padding: false
      )
      self.code_challenge_method = :s256
    end
  end
end
