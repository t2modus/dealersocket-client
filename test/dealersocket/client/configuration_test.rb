# frozen_string_literal: true

require 'test_helper'

module Dealersocket
  module Client
    class ConfigurationTest < ::Minitest::Test
      def configure_client(public_key, secret_key)
        Configuration.instance.configure(public_key: public_key, secret_key: secret_key)
      end

      def test_can_successfully_configure_the_client
        self.configure_client('test-public-key', 'test-secret-key')
        assert_equal 'test-public-key', Configuration.instance.public_key
        assert_equal 'test-secret-key', Configuration.instance.secret_key
      end

      def test_can_successfully_clear_configuration
        self.configure_client('test-public', 'test-secret')
        refute_nil Configuration.instance.public_key
        refute_nil Configuration.instance.secret_key
        Configuration.instance.clear!
        assert_nil Configuration.instance.public_key
        assert_nil Configuration.instance.secret_key
      end

      def test_configuration_with_no_public_key_or_secret_key_is_invalid
        refute Configuration.instance.valid?
      end

      def test_if_no_configuration_is_provided_then_configuration_from_environment_is_used
        ENV['DEALERSOCKET_PUBLIC_KEY'] = 'testing-env-public'
        ENV['DEALERSOCKET_SECRET_KEY'] = 'testing-env-secret'
        # unless this is the first test that runs, there's no way to NOT have the
        # singleton configuration class already defined by this point. So we'll
        # manually call the configure from environment method and then confirm
        # that that method is called by the initialize method
        Configuration.instance.configure_from_environment
        assert_equal 'testing-env-public', Configuration.instance.public_key
        assert_equal 'testing-env-secret', Configuration.instance.secret_key
      end

      def test_valid_succeeds_with_valid_configuration
        self.configure_client('test-public-key', 'test-secret-key')
        assert Configuration.instance.valid?
      end
    end
  end
end
