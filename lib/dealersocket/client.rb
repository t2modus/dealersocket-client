# frozen_string_literal: true

require 'active_support/all'
# used to build out HTML
require 'nokogiri'

%w[base activity base configuration customer event version].each do |path|
  require_relative "client/#{path}"
end

%w[base activity customer event].each do |path|
  require_relative "../xml/#{path}"
end

module Dealersocket
  # This module serves primarily as a namespace for the API code,
  # while also providing a few simple methods to allow configuration
  # of the API code with the appropriate credentials.
  module Client
    # this method provides access to allow configuring the object
    def self.configure(public_key: nil, secret_key: nil)
      if public_key.nil? && secret_key.nil?
        yield Configuration.instance
      else
        Configuration.instance.configure(public_key: public_key, secret_key: secret_key)
      end
    end

    # and this method provides a way to get the current configuration object
    def self.configuration
      Configuration.instance
    end
  end
end
