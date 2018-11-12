# frozen_string_literal: true

require 'singleton'
require 'http'

module Dealersocket
  module Client
    # This class is responsible for holding Authentication information for the Volie API
    class Configuration
      include Singleton

      attr_accessor :public_key, :secret_key

      def initialize
        self.configure_from_environment
      end

      def configure(public_key:, secret_key:)
        self.public_key = public_key
        self.secret_key = secret_key
      end

      def valid?
        [self.public_key, self.secret_key].none?(&:blank?)
      end

      # This method is primarily used for testing purposes, since we don't want
      # configuration from one test affecting configuration from another
      def clear!
        self.public_key, self.secret_key = []
      end

      def configure_from_environment
        self.configure(
          public_key: ENV['DEALERSOCKET_PUBLIC_KEY'],
          secret_key: ENV['DEALERSOCKET_SECRET_KEY']
        )
      end
    end
  end
end
