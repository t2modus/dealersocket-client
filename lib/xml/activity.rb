# frozen_string_literal: true

module XML
  # This class dynamically builds Activity to send to dealersocket
  class Activity < Base
    def create
      Nokogiri::XML::Builder.new do |xml|
        xml.ActivityInsert(
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
          'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema'
        ) do
          xml.Vendor 'T2Modus'
          xml.DealerId @variables[:dealer_number_id]
          xml.EntityId @variables[:customer_id]
          xml.EventId @variables[:event_id]
          xml.ActivityType @variables[:activity_type]
          xml.BatchId '0'
          xml.Status @variables[:status]
          xml.DueDateTime @variables[:due_date].strftime('%Y-%m-%dT%H:%M:%S.%6NZ')
          xml.Note @variables[:note]
        end
      end.to_xml
    end
  end
end
