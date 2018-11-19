# frozen_string_literal: true

module Dealersocket
  module Client
    # This class is responsible for logic for CRUD actions of Dealersocket customers
    class Customer < Base
      APPROVED_ATTRIBUTES = %i[id given_name family_name line_one city_name postcode state uriid dealer_number_id home
                               cell work].freeze
      CUSTOMER_INFO_FIELDS = %w[ShowCustomerInformation ShowCustomerInformationDataArea CustomerInformation].freeze
      INFO_TO_PARTY = %w[CustomerInformationDetail CustomerParty].freeze

      attr_accessor(*APPROVED_ATTRIBUTES)

      def initialize(attributes)
        attributes.slice(*APPROVED_ATTRIBUTES).each do |k, v|
          self.send("#{k}=", v)
        end
      end

      def attributes
        APPROVED_ATTRIBUTES.each_with_object({}) do |key, hash|
          hash[key] = self.send(key)
        end
      end

      def update(customer_params)
        updated_params = self.attributes.merge(customer_params)
        self.class.validate_params(%i[dealer_number_id id privacy_indicator given_name family_name], updated_params)
        self.class.request(
          method: :put,
          path: 'Customer',
          body: XML::Customer.new(updated_params.merge(transaction_type_code: 'UC')).create_or_update
        )
        true
      end

      class << self
        def create(customer_params)
          validate_params(%i[dealer_number_id privacy_indicator], customer_params)
          body = request(
            method: :post,
            path: 'Customer',
            body: XML::Customer.new(customer_params.merge(transaction_type_code: 'IC')).create_or_update
          )
          entity_id = body.dig('Response', 'EntityId')
          find(dealer_number_id: customer_params[:dealer_number_id], id: entity_id)
        end

        def find(customer_params)
          validate_params(%i[dealer_number_id id], customer_params)
          body = request(method: :post, path: 'SearchEntity', body: XML::Customer.new(customer_params).find)
          customer_info = [body.dig(*CUSTOMER_INFO_FIELDS)].flatten.compact.first
          customer_info.present? ? new(customer_info_to_hash(customer_info, customer_params[:dealer_number_id])) : nil
        end

        def search(customer_params)
          validate_params(%i[dealer_number_id], customer_params)
          body = request(method: :post, path: 'SearchEntity', body: XML::Customer.new(customer_params).search)
          customers_info = [body.dig(*CUSTOMER_INFO_FIELDS)].flatten.compact
          customers_info.map do |customer_info|
            new customer_info_to_hash(customer_info, customer_params[:dealer_number_id])
          end
        end

        def customer_info_to_hash(customer_info, dealer_number_id)
          party_hash = customer_info.dig(*INFO_TO_PARTY)
          person = party_hash['SpecifiedPerson']
          address = person['PostalAddress'] || {}
          phone_numbers = person['TelephoneCommunication'] || []
          phone_number_hash = phone_numbers.each_with_object({}) do |phone_number, object|
            key = phone_number['UseCode'].downcase.gsub('mobile', 'cell').to_sym
            object[key] = phone_number['CompleteNumber']
          end
          {
            id: party_hash['PartyID'],
            given_name: person['GivenName'],
            family_name: person['FamilyName'],
            line_one: address['LineOne'],
            city_name: address['CityName'],
            postcode: address['Postcode'],
            state: address['StateOrProvinceCountrySub_DivisionID']&.strip,
            uriid: person.dig('URICommunication', 'URIID')&.split(';')&.last,
            dealer_number_id: dealer_number_id
          }.merge(phone_number_hash)
        end
      end
    end
  end
end
