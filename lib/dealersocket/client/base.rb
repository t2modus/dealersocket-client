# frozen_string_literal: true

module Dealersocket
  module Client
    # This class is the base class containing logic common to all Dealersocket API classes
    class Base
      BASE_URL = 'https://api.dealersocket.com/api/DealerSocket/'
      attr_reader :attributes

      def initialize(attributes)
        @attributes = attributes.symbolize_keys.slice(*self.class.approved_attributes).with_indifferent_access
        self.define_attr_accessors
      end

      def define_attr_accessors
        return if @attributes.blank?
        @attributes.each_key do |attribute|
          define_singleton_method(attribute) { @attributes[attribute] }
          define_singleton_method("#{attribute}=") { |v| @attributes[attribute] = v }
        end
      end

      class << self
        def approved_attributes
          self::APPROVED_ATTRIBUTES
        end

        def create_http_request(data)
          hash = generate_hmac_hash_for_authentication(data)
          HTTP.headers(
            'Content-Type' => 'application/xml',
            'Authentication' => "#{Configuration.instance.public_key}:#{hash}"
          )
        end

        def generate_hmac_hash_for_authentication(data)
          digest = OpenSSL::Digest.new('sha256')
          Base64.encode64(OpenSSL::HMAC.digest(digest, Configuration.instance.secret_key, data)).strip
        end

        def handle_response(response, success_codes = [200])
          succeeded = success_codes.include? response.code
          unless succeeded
            raise Error, "Received an error (#{response.code}) from the Dealersocket Servers: #{response.body}"
          end
          Hash.from_xml(response.body)
        end

        def request(method:, path:, body:)
          validate_configured!
          handle_response create_http_request(body).send(method, request_url(path: path), body: body)
        end

        def request_url(path:)
          "#{BASE_URL}/#{path}"
        end

        def validate_configured!
          error_message = 'Dealersocket must be configured with a valid API public key and secret key before use.'
          raise Error, error_message unless Configuration.instance.valid?
        end

        def validate_params(required_keys, params)
          all_required_params_present = required_keys.all? { |key| params[key] == false || params[key].present? }
          return if all_required_params_present
          raise Error, "The following parameters are required for your request: #{required_keys.join(', ')}"
        end
      end
    end
  end
end
