# frozen_string_literal: true

module Dealersocket
  module Client
    # This class is responsible for logic for CRUD actions of Dealersocket events/opportunities
    class Event < Base
      APPROVED_ATTRIBUTES = %i[id customer_id].freeze

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

      def update(event_params)
        event_params = self.attributes.merge(event_params)
        self.class.validate_params(%i[id], event_params)
        self.class.request(method: :post, path: 'eventsales', body: XML::Event.new(event_params).update)
        true
      end

      class << self
        def create(event_params)
          validate_params(%i[direct_lead_id], event_params)
          direct_lead_id = event_params[:direct_lead_id]
          url = "https://oemwebsecure.dealersocket.com/DSOEMLead/US/DCP/ADF/1/SalesLead/#{direct_lead_id}"
          username_and_password = "#{ENV['DEALERSOCKET_USERNAME']}:#{ENV['DEALERSOCKET_PASSWORD']}"
          response = HTTP.headers(:accept => 'application/xml', 'Authorization' => username_and_password)
                         .post(url, body: XML::Event.new(event_params).create)
          body = Hash.from_xml(response.body).dig('LeadResponse')
          id = [body['DSLeadId'].to_i, body['DSExistingLeadId'].to_i].max
          return false if id.blank? || id.zero?
          customer_id = body['DSCustomerId']
          new(id: id, customer_id: customer_id)
        end
      end
    end
  end
end
