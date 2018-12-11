# frozen_string_literal: true

require 'test_helper'
require 'helpers/base_helper'

module Dealersocket
  module Client
    class EventTest < Minitest::Test
      include BaseHelper

      def setup
        use_default_configuration
        @model = Event.new(id: 1, customer_id: 1, dealer_number_id: '1')
      end

      def test_update_returns_true_if_update_else_error
        Event.stubs(:request).returns(update_success_response, update_bad_response)
        Event.expects(:validate_params).twice
        assert @model.update(priority_ranking: 3)
        error = assert_raises(Error) { @model.update(priority_ranking: 3) }
        assert_equal 'invalid username in ProviderParty.PartyID.Value: T2Modus', error.message
      end

      def test_create_returns_event_if_new_or_existing
        ::Dealersocket::Client.configure(public_key: 'fake', secret_key: 'faker', username: 'ufake', password: 'fakep')
        Event.expects(:validate_params).twice
        stub_request(
          :post,
          'https://oemwebsecure.dealersocket.com/DSOEMLead/US/DCP/ADF/1/SalesLead/22wefIV3ds9'
        ).to_return(body: create_success_response, status: 200)
        event = Event.create(event_params)
        assert_equal Event, event.class
        stub_request(
          :post,
          'https://oemwebsecure.dealersocket.com/DSOEMLead/US/DCP/ADF/1/SalesLead/22wefIV3ds9'
        ).to_return(body: create_existing_response, status: 200)
        event = Event.create(event_params)
        assert_equal Event, event.class
      end

      def test_validate_username_and_password
        error = assert_raises(Error) { Event.create(event_params) }
        assert_equal 'A valid username and password is required for calls to Event.create.', error.message
      end

      private

      def event_params
        {
          given_name: 'Malik',
          family_name: 'Jordan',
          line_one: '322 ossabaw dr',
          city_name: 'murfreesboro',
          postcode: '37128',
          state: 'tn',
          uriid: 'm.k.jordan17@gmail.com',
          home: '9314923970',
          cell: nil,
          work: '6158934380',
          phone: '9314923970',
          dealer_number_id: '50_616',
          year: 2018,
          make: 'nissan',
          model: 'titan',
          vin: '1N6AA1E65JN527876',
          trim: nil,
          vendorname: 'Test Dealer',
          vehicle_note: 8,
          customer_id: '768999',
          priority_ranking: 2,
          direct_lead_id: '22wefIV3ds9'
        }
      end

      # The XML returned by dealersocket here needs to be exact otherwise parsing doesn't work right
      # rubocop:disable Style/StringLiterals
      # rubocop:disable Metrics/LineLength
      def create_existing_response
        Nokogiri::XML("<LeadResponse xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"><DSExistingLeadId>2215758</DSExistingLeadId><DSLeadId>0</DSLeadId><DSCustomerId>0</DSCustomerId><DSDealerId>3250_0</DSDealerId><DSAssignedId>DCPqa</DSAssignedId><DSAssignedName>Ash Bhattari</DSAssignedName><ErrorCode i:nil=\"true\" /><ErrorMessage i:nil=\"true\" /><StackTrace i:nil=\"true\" /><Success>true</Success></LeadResponse>").to_xml
      end

      def create_success_response
        Nokogiri::XML("<LeadResponse xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"><DSExistingLeadId>0</DSExistingLeadId><DSLeadId>2215758</DSLeadId><DSCustomerId>768863</DSCustomerId><DSDealerId>3250_0</DSDealerId><DSAssignedId>DCPqa</DSAssignedId><DSAssignedName>Ash Bhattari</DSAssignedName><ErrorCode i:nil=\"true\" /><ErrorMessage i:nil=\"true\" /><StackTrace i:nil=\"true\" /><Success>true</Success></LeadResponse>").to_xml
      end
      # rubocop:enable Metrics/LineLength
      # rubocop:enable Style/StringLiterals

      def update_bad_response
        { 'Response' =>
          { 'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.dealersocket.com',
            'Success' => 'false',
            'ErrorCode' => 'SAVE_DATA',
            'ErrorMessage' => 'invalid username in ProviderParty.PartyID.Value: T2Modus' } }
      end

      def update_success_response
        { 'Response' =>
          { 'xmlns:xsd' =>
            'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.dealersocket.com',
            'Success' => 'true' } }
      end
    end
  end
end
