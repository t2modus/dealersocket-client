# frozen_string_literal: true

module Dealersocket
  module Client
    # This class is responsible for logic for CRUD actions of Dealersocket events/opportunities
    class Event < Base
      APPROVED_ATTRIBUTES = %i[id customer_id dealer_number_id].freeze

      def update(event_params)
        event_params = self.attributes.merge(event_params)
        self.class.validate_params(%i[id], event_params)
        response = self.class.request(method: :post, path: 'eventsales', body: XML::Event.new(event_params).update)
        success = response.dig('Response', 'Success') == 'true'
        return success if success
        raise Error, response.dig('Response', 'ErrorMessage')
      end

      class << self
        def create(event_params)
          validate_username_and_password!
          validate_params(%i[direct_lead_id], event_params)
          direct_lead_id = event_params[:direct_lead_id]
          url = "https://oemwebsecure.dealersocket.com/DSOEMLead/US/DCP/ADF/1/SalesLead/#{direct_lead_id}"
          response = HTTP.headers(:accept => 'application/xml',
                                  'Authorization' => Configuration.instance.username_and_password)
                         .post(url, body: XML::Event.new(event_params).create)
          body = Hash.from_xml(response.body).dig('LeadResponse')
          id = [body['DSLeadId'].to_i, body['DSExistingLeadId'].to_i].max
          return false if id.blank? || id.zero?
          customer_id = body['DSCustomerId']
          new(id: id, customer_id: customer_id, dealer_number_id: event_params[:dealer_number_id])
        end

        def validate_username_and_password!
          error_message = 'A valid username and password is required for calls to Event.create.'
          raise Error, error_message unless Configuration.instance.valid_username_and_password?
        end
      end
    end
  end
end
