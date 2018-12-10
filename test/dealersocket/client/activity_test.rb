# frozen_string_literal: true

require 'test_helper'
require 'helpers/base_helper'

module Dealersocket
  module Client
    class ActivityTest < Minitest::Test
      include BaseHelper

      def setup
        use_default_configuration
        @model = Activity.new(id: 1, customer_id: 1, event_id: 1, dealer_number_id: '1')
      end

      def test_activity_create_returns_false_if_response_does_not_contain_id
        Activity.stubs(:request).returns(bad_response)
        error = assert_raises Error do
          Activity.create(activity_params)
        end
        assert_equal 'EventId does not exist.', error.message
      end

      def test_activity_create_returns_a_new_activity
        Activity.stubs(:request).returns(success_response)
        Activity.expects(:validate_params).once
        activity = Activity.create(activity_params)
        assert_equal Activity, activity.class
      end

      private

      def activity_params
        {
          dealer_number_id: 'T35T',
          customer_id: '123533',
          event_id: '433553',
          activity_type: 'Outbound_Call',
          status: 'Completed',
          due_date: 10.minutes.ago,
          note: 'This is a test note.'
        }
      end

      def bad_response
        {
          'ActivityResponse' =>
          {
            'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.dealersocket.com',
            'Success' => 'false',
            'ErrorCode' => 'EVENTID_INVALID',
            'ErrorMessage' => 'EventId does not exist.',
            'ActivityId' => '0'
          }
        }
      end

      def success_response
        {
          'ActivityResponse' =>
          {
            'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns' => 'http://www.dealersocket.com',
            'Success' => 'true',
            'ActivityId' => '5546528'
          }
        }
      end
    end
  end
end
