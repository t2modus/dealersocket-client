# frozen_string_literal: true

require 'test_helper'

module XML
  class EventTest < Minitest::Test
    def setup
      @builder = Event.new(event_params)
    end

    def test_create_xml
      xml = @builder.create
      assert xml.include?('<id source="T2modus.com" sequence="1">1494077439</id>')
      assert xml.include?('<vin>1N6AA1E65JN527876</vin>')
      assert xml.include?('<street line="1">322 ossabaw dr</street>')
    end

    def test_update_xml
      xml = @builder.update
      assert xml.include?('xmlns="http://www.starstandard.org/STAR/5"')
      assert xml.include?('<ManufacturerName>nissan</ManufacturerName>')
      assert xml.include?('<PartyID>768999</PartyID>')
      assert xml.include?('<PriorityRankingNumeric>2</PriorityRankingNumeric>')
      assert xml.include?('<GivenName>Howard</GivenName>')
      assert xml.include?('<FamilyName>Stark</FamilyName>')
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
        direct_lead_id: '22wefIV3ds9',
        employee_name: 'Howard Stark'
      }
    end
  end
end
