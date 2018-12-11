# frozen_string_literal: true

require 'test_helper'

module Dealersocket
  module Client
    class BaseTest < Minitest::Test
      def setup
        use_default_configuration
      end

      def test_create_http_request_adds_auth_and_xml_to_header
        headers = Base.create_http_request(xml_body).default_options.headers
        assert_equal 'application/xml', headers['Content-Type']
        assert headers['Authentication'].present?
      end

      def test_generates_hash_from_body
        hash = Base.generate_hmac_hash_for_authentication(xml_body)
        assert_equal 'gFKBSj9HYVMPmJdQnr4KyVFnvSRyQ9hJ2wa6WSOAbFo=', hash
      end

      def test_handle_response_throws_error_if_code_is_error
        response = OpenStruct.new(code: 400, body: xml_response)
        error = assert_raises Error do
          Base.handle_response(response)
        end
        assert_equal "Received an error (400) from the Dealersocket Servers: #{xml_response}", error.message
      end

      def test_handle_response_converts_xml_to_hash_if_not_error
        response = OpenStruct.new(code: 200, body: xml_response)
        assert_equal({ 'fakeResponse' => { 'Success' => 'false' } }, Base.handle_response(response))
      end

      def test_request_validates_configuration_and_handles_response
        Base.expects(:validate_configured!).once
        Base.expects(:handle_response).once
        HTTP::Client.any_instance.stubs(:fake).returns(true)
        Base.request(method: 'fake', path: 'faker', body: 'fakest')
      end

      def test_request_url
        assert_equal 'https://api.dealersocket.com/api/DealerSocket/fake', Base.request_url(path: 'fake')
      end

      def test_validate_configured_throws_error_if_not_configured
        Configuration.instance.clear!
        error = assert_raises Error do
          Base.validate_configured!
        end
        assert_equal 'Dealersocket must be configured with a valid API public key and secret key before use.',
                     error.message
      end

      def test_validate_params_accepts_false_but_not_other_blank_values
        required_keys = %i[a b c]
        params = { a: '1', b: false, c: 2 }
        assert Base.validate_params(required_keys, params)
        params[:c] = ''
        assert_raises(Error) { Base.validate_params(required_keys, params) }
        params = { a: '1', b: false }
        error = assert_raises(Error) { Base.validate_params(required_keys, params) }
        assert_equal 'The following parameters are required for your request: a, b, c', error.message
      end

      private

      def xml_body
        Nokogiri::XML('<fake><xml>text</xml></fake>').to_xml
      end

      def xml_response
        Nokogiri::XML('<fakeResponse><Success>false</Success></fakeResponse>').to_xml
      end
    end
  end
end
