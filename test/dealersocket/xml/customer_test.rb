# frozen_string_literal: true

require 'test_helper'

module XML
  class CustomerTest < Minitest::Test
    def setup
      @builder = Customer.new(customer_params)
    end

    def test_find_xml
      xml = @builder.find
      assert xml.include?('<DealerNumberID>432_090</DealerNumberID>')
      assert xml.include?('<CustomerInformation>')
      assert xml.include?('<PartyID>1233</PartyID>')
    end

    def test_search_xml
      xml = @builder.search
      assert xml.include?('<DealerNumberID>432_090</DealerNumberID>')
      assert xml.include?('<CustomerInformation>')
      assert xml.include?('<GivenName>Inigo</GivenName>')
      assert xml.include?('<URIID>die@youkilledmyfatherprepareto.die</URIID>')
      assert xml.include?('<CompleteNumber>1111111111</CompleteNumber>')
    end

    def test_create_or_update_xml
      xml = @builder.create_or_update
      assert xml.include?('<ID>1233</ID>')
      assert xml.include?('<LineOne>You Killed my Father</LineOne>')
      customer_params.slice(:home, :cell, :work).each_value do |v|
        assert xml.include?("<CompleteNumber>#{v}</CompleteNumber>")
      end
      assert xml.include?('<PrivacyIndicator>true</PrivacyIndicator>')
    end

    private

    def customer_params
      {
        id: 1233,
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
        privacy_indicator: true,
        phone: '1111111111'
      }
    end
  end
end
