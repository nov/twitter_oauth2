RSpec.describe TwitterOAuth2 do
  its(:version) do
    TwitterOAuth2::VERSION.should_not be_blank
  end

  describe 'debugging feature' do
    after { TwitterOAuth2.debugging = false }

    its(:logger) { should be_a Logger }
    its(:debugging?) { should == false }

    describe '.debug!' do
      before { TwitterOAuth2.debug! }
      its(:debugging?) { should == true }
    end

    describe '.debug' do
      it 'should enable debugging within given block' do
        TwitterOAuth2.debug do
          Rack::OAuth2.debugging?.should == true
          TwitterOAuth2.debugging?.should == true
        end
        Rack::OAuth2.debugging?.should == false
        TwitterOAuth2.debugging?.should == false
      end

      it 'should not force disable debugging' do
        Rack::OAuth2.debug!
        TwitterOAuth2.debug!
        TwitterOAuth2.debug do
          Rack::OAuth2.debugging?.should == true
          TwitterOAuth2.debugging?.should == true
        end
        Rack::OAuth2.debugging?.should == true
        TwitterOAuth2.debugging?.should == true
      end
    end
  end
end
