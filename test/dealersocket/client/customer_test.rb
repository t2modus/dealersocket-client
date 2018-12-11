# frozen_string_literal: true

require 'test_helper'
require 'helpers/base_helper'

module Dealersocket
  module Client
    class CustomerTest < Minitest::Test
      include BaseHelper

      def setup
        use_default_configuration
        @model = Customer.new(id: 768_999, given_name: 'Dwayne', family_name: 'Johnson', line_one: '543 N Hollywood',
                              city_name: 'Hollywood', postcode: '90001', state: 'CA', uriid: 'therock@me.com',
                              dealer_number_id: '123_09', home: '4446667775', cell: '7776665555', work: '8273633323')
      end

      def test_update_customer_returns_true_or_false_depending_on_response
        Customer.stubs(:request).returns(update_success_response, update_bad_response)
        Customer.expects(:validate_params).twice
        assert @model.update(given_name: 'The Rock')
        refute @model.update(given_name: 'The Rocke')
      end

      def test_customer_create_finds_a_new_customer_based_on_id
        Customer.stubs(:request).returns(create_success_response)
        Customer.expects(:validate_params).once
        Customer.expects(:find).once
        Customer.create(customer_params)
      end

      def test_customer_find_instantiates_new_customer_if_exists_else_nil
        Customer.stubs(:request).returns(find_success_response, find_bad_response)
        Customer.expects(:validate_params).twice
        customer = Customer.find(customer_params)
        assert_equal Customer, customer.class
        assert_nil Customer.find(customer_params)
      end

      def test_customer_search_instantiates_new_customers_if_exists_else_empty_array
        Customer.stubs(:request).returns(search_success_response, search_bad_response)
        Customer.expects(:validate_params).twice
        customers = Customer.search(customer_params)
        assert_equal 2, customers.length
        customers.each { |c| assert c.is_a?(Customer) }
        assert_equal [], Customer.search(customer_params)
      end

      private

      def customer_params
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

      def customer_info
        { 'CustomerInformationHeader' => { 'SecondaryDealerNumberID' => 'DCP QA' },
          'CustomerInformationDetail' =>
          { 'CustomerParty' =>
            { 'PartyID' => '769239',
              'SpecifiedPerson' =>
              { 'GivenName' => 'Inigo',
                'FamilyName' => 'Montoya',
                'GenderCode' => 'M',
                'TelephoneCommunication' =>
                [{ 'CompleteNumber' => '1111111111', 'UseCode' => 'Home' },
                 { 'CompleteNumber' => '1111121112', 'UseCode' => 'Mobile' },
                 { 'CompleteNumber' => '1111131113', 'UseCode' => 'Work' }],
                'URICommunication' =>
                { 'URIID' => 'die@youkilledmyfatherprepareto.die', 'ChannelCode' => 'email address' },
                'PostalAddress' =>
                { 'LineOne' => 'You Killed My Father',
                  'CityName' => 'prepare',
                  'Postcode' => '98765',
                  'StateOrProvinceCountrySub_DivisionID' => 'TO  ' } } } } }
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

      def find_bad_response
        { 'ShowCustomerInformation' =>
          { 'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.starstandard.org/STAR/5',
            'ShowCustomerInformationDataArea' =>
            { 'Show' =>
              { 'ResponseCriteria' =>
                { 'xmlns' => 'http://www.openapplications.org/oagis/9', 'ResponseExpression' => 'success' } } } } }
      end

      def find_success_response
        { 'ShowCustomerInformation' =>
          { 'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.starstandard.org/STAR/5',
            'ShowCustomerInformationDataArea' =>
            { 'Show' =>
              { 'ResponseCriteria' =>
                { 'xmlns' => 'http://www.openapplications.org/oagis/9', 'ResponseExpression' => 'success' } },
              'CustomerInformation' =>
              customer_info } } }
      end

      def search_bad_response
        find_bad_response
      end

      def search_success_response
        { 'ShowCustomerInformation' =>
          { 'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.starstandard.org/STAR/5',
            'ShowCustomerInformationDataArea' =>
            { 'Show' =>
              { 'ResponseCriteria' =>
                { 'xmlns' => 'http://www.openapplications.org/oagis/9', 'ResponseExpression' => 'success' } },
              'CustomerInformation' =>
              [customer_info, customer_info] } } }
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
