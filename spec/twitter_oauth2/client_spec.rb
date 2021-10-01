RSpec.describe TwitterOAuth2::Client do
  subject { client }
  let(:client) { TwitterOAuth2::Client.new attributes }
  let(:attributes) { required_attributes }
  let(:required_attributes) do
    {
      identifier: 'client_id'
    }
  end

  describe 'endpoints' do
    its(:authorization_endpoint) { should == 'https://twitter.com/i/oauth2/authorize' }
    its(:token_endpoint) { should == 'https://api.twitter.com/2/oauth2/token' }
  end

  describe '#authorization_uri' do
    before do
      @authorization_uri, @code_verifier = client.authorization_uri
    end

    describe 'query' do
      subject do
        query = URI.parse(@authorization_uri).query
        Rack::Utils.parse_query(query).with_indifferent_access
      end

      it do
        should include :code_challenge
      end
      it do
        should include :code_challenge_method
      end
      its([:code_challenge_method]) do
        should == 's256'
      end
    end

    describe 'code_verifier' do
      it do
        @code_verifier.should_not be_blank
      end
    end
  end

  describe '#access_token!' do
    let(:code_verifier) { SecureRandom.hex 8 }
    let(:access_token) do
      client.authorization_code = 'code'
      client.access_token! code_verifier
    end

    context 'when error is returned' do
      it 'should raise Rack::OAuth2::Client::Error' do
        mock_response :post, client.token_endpoint, 'access_token/invalid_request', status: 400 do
          expect do
            access_token
          end.to raise_error Rack::OAuth2::Client::Error
        end
      end
    end

    context '*args handling' do
      describe 'code grant' do
        before do
          client.authorization_code = 'code'
        end

        context 'when code_verifier is given as the first args' do
          it do
            mock_response(
              :post,
              'https://api.twitter.com/2/oauth2/token',
              'access_token/bearer',
              params: {
                client_id: 'client_id',
                grant_type: 'authorization_code',
                code: 'code',
                code_verifier: 'code_verifier'
              }
            ) do
              client.access_token! 'code_verifier'
            end
          end
        end

        context 'when code_verifier is given as hash member' do
          it do
            mock_response(
              :post,
              'https://api.twitter.com/2/oauth2/token',
              'access_token/bearer',
              params: {
                client_id: 'client_id',
                grant_type: 'authorization_code',
                code: 'code',
                code_verifier: 'code_verifier'
              }
            ) do
              client.access_token! code_verifier: 'code_verifier'
            end
          end
        end

        context 'otherwise' do
          it do
            mock_response(
              :post,
              'https://api.twitter.com/2/oauth2/token',
              'access_token/bearer',
              params: {
                client_id: 'client_id',
                grant_type: 'authorization_code',
                code: 'code'
              }
            ) do
              client.access_token!
            end
          end
        end
      end

      describe 'refresh_token grant' do
        before do
          client.refresh_token = 'refresh_token'
        end

        it do
          mock_response(
            :post,
            'https://api.twitter.com/2/oauth2/token',
            'access_token/bearer',
            params: {
              client_id: 'client_id',
              grant_type: 'refresh_token',
              refresh_token: 'refresh_token'
            }
          ) do
            client.access_token!
          end
        end
      end
    end
  end
end
