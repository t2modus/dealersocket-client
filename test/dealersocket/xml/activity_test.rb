# frozen_string_literal: true

require 'test_helper'

module XML
  class ActivityTest < Minitest::Test
    def test_create_xml
      xml = Activity.new(activity_params).create
      assert xml.include?('<EventId>3</EventId>')
      assert xml.include?('<Note/>')
    end

    private

    def activity_params
      {
        dealer_number_id: '1',
        customer_id: '2',
        event_id: '3',
        activity_type: 'Outbound_Call',
        status: 'Completed',
        due_date: Time.current,
        note: ''
      }
    end
  end
end
