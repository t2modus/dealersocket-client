# frozen_string_literal: true

module XML
  # This class dynamically builds xml to send to dealersocket
  class Base
    def initialize(variables)
      @variables = variables
    end

    protected

    def application_area(xml, service_message_id)
      xml.ApplicationArea do
        xml.Sender do
          xml.CreatorNameCode 'T2Modus'
          xml.SenderNameCode 'T2Modus'
          xml.DealerNumberID @variables[:dealer_number_id]
        end
        xml.Destination do
          xml.DealerNumberID 1
          xml.DestinationNameCode 'DS'
          xml.ServiceMessageID service_message_id
        end
        xml.CreationDateTime Time.current.strftime('%Y-%m-%dT%H:%M:%S')
      end
    end

    def default_namespace_hash
      {
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
        'xmlns' => 'http://www.starstandard.org/STAR/5'
      }
    end
  end
end
