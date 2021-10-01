require 'webmock/rspec'

module WebMockHelper
  def mock_response(method, endpoint, response_file, options = {})
    stub_request(method, endpoint).with(
      request_for(method, options)
    ).to_return(
      response_for(response_file, options)
    )
    result = yield
    a_request(method, endpoint).should have_been_made.once
    result
  end

  def request_to(endpoint, method = :get)
    raise_error { |e|
      e.should be_instance_of WebMock::NetConnectNotAllowedError
      e.message.should include("Unregistered request: #{method.to_s.upcase}")
      e.message.should include(endpoint)
    }
  end

  private

  def request_for(method, options = {})
    request = {}
    params = options.try(:[], :params) || {}
    case method
    when :post, :put, :delete
      request[:body] = params
    else
      request[:query] = params
    end
    if options[:request_header]
      request[:headers] = options[:request_header]
    end
    request
  end

  def response_for(response_file, options = {})
    response = {}
    response[:body] = File.new(File.join(File.dirname(__FILE__), '../mock_response', "#{response_file}.#{options[:format] || :json}"))
    if options[:status]
      response[:status] = options[:status]
    end
    response
  end
end

include WebMockHelper
WebMock.disable_net_connect!
