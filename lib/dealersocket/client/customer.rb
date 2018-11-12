# frozen_string_literal: true

module Dealersocket
  module Client
    # This class is responsible for logic for CRUD actions of Dealersocket customers
    class Customer < Base
      def create(customer_params)
        begin
          request(
            method: :post,
            path: 'Customer',
            body: create_or_update_customer_xml(customer_params.merge(request_type: 'IC'))
          )
        rescue REXML::ParseException
          handle_parse_exception(response, customer_object)
        end
        [check_customer_response(body['Response']), customer_object]
      end

      def find
      end

      def search
      end

      def update(customer_params)
        request(
          method: :put,
          path: 'Customer',
          body: create_or_update_customer_xml(customer_params.merge(request_type: 'UC'))
        )
      end

      private

      def handle_parse_exception(response, customer_object)
        response_text = response.body.to_s
        customer_object, body = if response_text =~ /DUPLICATE_ENTITY/
                                  handle_duplicates(response_text, dealership_id)
                                elsif response_text =~ /ENTITY_NOT_NULL/ && t2_customer.present?
                                  handle_not_null(response_text, t2_customer)
                                end
      end

      def handle_duplicates(response_text, dealership_id)
        duplicate_id = response_text.scan(/\[[0-9]+/).first&.tr('^0-9', '')&.to_i
        customer_object = Customer.find
      end
    end
  end
end
