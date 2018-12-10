# frozen_string_literal: true

require 'test_helper'

module Dealersocket
  class ClientTest < Minitest::Test
    def test_can_configure_with_block
      assert_nil Client::Configuration.instance.public_key
      assert_nil Client::Configuration.instance.secret_key
      Client.configure do |config|
        config.public_key = 'test-access'
        config.secret_key = 'test-secret'
      end
      assert_equal 'test-access', Client::Configuration.instance.public_key
      assert_equal 'test-secret', Client::Configuration.instance.secret_key
    end

    def test_can_configure_with_arguments
      assert_nil Client::Configuration.instance.public_key
      assert_nil Client::Configuration.instance.secret_key
      Client.configure(public_key: 'test-access', secret_key: 'test-secret')
      assert_equal 'test-access', Client::Configuration.instance.public_key
      assert_equal 'test-secret', Client::Configuration.instance.secret_key
    end

    def test_can_get_configuration
      Client.configure(public_key: 'access', secret_key: 'secret')
      assert_equal 'access', Client.configuration.public_key
      assert_equal 'secret', Client.configuration.secret_key
    end
  end
end
