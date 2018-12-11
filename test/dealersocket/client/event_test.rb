# frozen_string_literal: true

require 'test_helper'
require 'helpers/base_helper'

module Dealersocket
  module Client
    class EventTest < Minitest::Test
      include BaseHelper

      def setup
        use_default_configuration
        # Configuration.configure_username_and_password(username: 'fake', password: 'faker')
        @model = Event.new(id: 1, customer_id: 1, dealer_number_id: '1')
      end

      # def test_update_customer_returns_true_or_false_depending_on_response
      #   Customer.stubs(:request).returns(update_success_response, update_bad_response)
      #   Customer.expects(:validate_params).twice
      #   assert @model.update(given_name: 'The Rock')
      #   refute @model.update(given_name: 'The Rocke')
      # end
      #
      # def test_customer_create_finds_a_new_customer_based_on_id
      #   Customer.stubs(:request).returns(create_success_response)
      #   Customer.expects(:validate_params).once
      #   Customer.expects(:find).once
      #   Customer.create(customer_params)
      # end

      private

      def event_params
        {
          given_name: 'Inigo',
          family_name: 'Montoya',
          line_one: 'You Killed my Father',
          city_name: 'prepare',
          postcode: '98765',
          state: 'TO',
          uriid: 'die@youkilledmyfatherprepareto.die',
          home: '1111111111',
          cell: '1111121112',
          work: '1111131113',
          dealer_number_id: '432_090',
          privacy_indicator: true
        }
      end

      def create_existing_response
      end

      def create_success_response
        {
          'Response' =>
          {
            'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.dealersocket.com',
            'Success' => 'true',
            'Message' => 'Success Inserting Customer, EntityId: 769239',
            'EntityId' => '769239'
          }
        }
      end

      def update_bad_response
        {
          'Response' =>
          {
            'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.dealersocket.com',
            'Success' => 'false',
            'Message' => 'Could not update customer',
            'EntityId' => '0'
          }
        }
      end

      def update_success_response
        {
          'Response' =>
          {
            'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.dealersocket.com',
            'Success' => 'true',
            'Message' => 'Updated customer successfully, EntityId: 768999',
            'EntityId' => '768999'
          }
        }
      end
    end
  end
end
