# frozen_string_literal: true

module XML
  # This class dynamically builds Activity to send to dealersocket
  class Activity < Base
    def create
      Nokogiri::XML::Builder.new do |xml|
        xml.ActivityInsert(default_namespace_hash) do
          xml.Vendor 'T2Modus'
          xml.DealerId @variables[:dealer_id]
          xml.EntityId @variables[:entity_id]
          xml.EventId @variables[:event_id]
          xml.ActivityType @variables[:activity_type]
          xml.BatchId '0'
          xml.ExternalId('type' => 'OemLeadId') { xml.text '1494077439' }
          xml.DueDateTime Time.current.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          xml.Note @variables[:note]
        end
      end.to_xml
    end
  end
end
