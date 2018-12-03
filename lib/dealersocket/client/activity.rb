# frozen_string_literal: true

module Dealersocket
  module Client
    # This class is responsible for logic for CRUD actions of Dealersocket activities
    class Activity < Base
      APPROVED_ATTRIBUTES = %i[id customer_id event_id dealer_number_id].freeze

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

      class << self
        def create(activity_params)
          validate_params(%i[dealer_number_id customer_id event_id activity_type due_date], activity_params)
          body = request(
            method: :post,
            path: 'Activity',
            body: XML::Activity.new(activity_params).create
          )
          id = body.dig('ActivityResponse', 'ActivityId')
          return false if id.blank?
          new(
            id: id,
            customer_id: activity_params[:customer_id],
            event_id: activity_params[:event_id],
            dealer_number_id: activity_params[:dealer_number_id]
          )
        end
      end
    end
  end
end
