# frozen_string_literal: true

module Dealersocket
  module Client
    # This class is responsible for logic for CRUD actions of Dealersocket customers
    class Customer < Base
      CUSTOMER_INFO_FIELDS = %w[ShowCustomerInformation ShowCustomerInformationDataArea CustomerInformation].freeze
      INFO_TO_PARTY = %w[CustomerInformationDetail CustomerParty].freeze

      attr_accessor :id, :given_name, :family_name, :phone_numbers, :emails, :addresses

      def initialize(customer_info)
        party_hash = customer_info.dig(*INFO_TO_PARTY)
        person = party_hash['SpecifiedPerson']
        self.id = party_hash['PartyID']
        self.given_name = person['GivenName']
        self.family_name = person['FamilyName']
        self.phone_numbers = define_phone_numbers(person['TelephoneCommunication'])
        self.emails = define_emails(person['URICommunication'])
        self.addresses = person['PostalAddress']
      end

      private

      def define_phone_numbers(phones)
        [phones].flatten.compact.map { |phone| { phone['CompleteNumber'] => phone['UseCode'] } }
      end

      def define_emails(comms)
        [comms].flatten.compact.map { |comm| comm['URIID'] if comm['ChannelCode'].match?(/email/i) }.compact
      end

      class << self
        def create(customer_params)
          body = request(
            method: :post,
            path: 'Customer',
            body: XML::Customer.new(customer_params.merge(transaction_type_code: 'IC')).create_or_update
          )
          entity_id = body.dig('Response', 'EntityId')
          find(dealer_number_id: customer_params[:dealer_number_id], customer_id: entity_id)
        end

        def find(customer_params)
          body = request(method: :post, path: 'SearchEntity', body: XML::Customer.new(customer_params).find)
          customer_info = [body.dig(*CUSTOMER_INFO_FIELDS)].flatten.compact.first
          new customer_info
        end

        def search(customer_params)
          body = request(method: :post, path: 'SearchEntity', body: XML::Customer.new(customer_params).search)
          customers_info = [body.dig(*CUSTOMER_INFO_FIELDS)].flatten.compact
          customers_info.map do |customer_info|
            new customer_info
          end
        end

        def update(customer_params)
          request(
            method: :put,
            path: 'Customer',
            body: XML::Customer.new(customer_params.merge(transaction_type_code: 'UC')).create_or_update
          )
          true
        end
      end
    end
  end
end
