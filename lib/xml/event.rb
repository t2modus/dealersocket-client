# frozen_string_literal: true

module XML
  # This class dynamically builds event/opportunity xml to send to dealersocket
  class Event < Base
    def find_or_create
      Nokogiri::XML::Builder.new do |xml|
        xml.adf do
          xml.prospect do
            xml.id('source' => 'T2modus.com', 'sequence' => '1') { xml.text '1494077439' }
            xml.requestdate Time.current
            xml.vehicle do
              xml.year @variables[:year]
              xml.make @variables[:make]
              xml.model @variables[:model]
              xml.vin @variables[:vin]
              xml.trim @variables[:trim]
              xml.colorcombination do
                xml.interiorcolor @variables[:interiorcolor]
                xml.exteriorcolor @variables[:exteriorcolor]
                xml.preference '1'
              end
              xml.comments
            end
            xml.customer do
              xml.contact do
                xml.name('part' => 'first') { xml.text @variables[:first_name] }
                xml.name('part' => 'last') { xml.text @variables[:last_name] }
                xml.email @variables[:email]
                xml.phone('type' => 'voice', 'time' => 'evening') { xml.text @variables[:phone] }
                xml.address do
                  xml.street('line' => '1') { xml.text @variables[:street_1] }
                  xml.street('line' => '2') { xml.text @variables[:street_2] }
                  xml.city @variables[:city]
                  xml.regioncode @variables[:state]
                  xml.postalcode @variables[:postalcode]
                end
              end
            end
            xml.vendor do
              xml.vendorname @variables[:vendorname]
            end
            xml.provider do
              xml.name('part' => 'full') { xml.text 'T2modus.com' }
              xml.email 'support@t2modus.com'
              xml.contact do
                xml.name('part' => 'full') { xml.text 'T2 Modus'}
                xml.email 'support@t2modus.com'
              end
            end
          end
        end
      end.to_xml
    end

    def update
      Nokogiri::XML::Builder.new do |xml|
        xml.ProcessSalesLead(default_namespace_hash) do
          application_area(xml, 'XXXXXX')
          xml.ProcessSalesLeadDataArea do
            xml.SalesLead do
              xml.SalesLeadDetail do
                xml.LeadStatus 'Contacted'
                xml.SalesActivity do
                  xml.SalesPersonName
                  xml.Vehicle do
                    xml.ManufacturerName @variables[:manufacturer_name]
                    xml.ModelDescription @variables[:model_description]
                    xml.ModelYear @variables[:model_year]
                    xml.VehicleID @variables[:vehicle_id]
                    xml.VehicleNote @variables[:vehicle_note]
                    xml.VehicleStockString
                  end
                end
              end
              xml.SalesLeadHeader do
                xml.DocumentDateTime
                xml.LeadComments
                xml.LeadInterestCode 'Purchase'
                xml.SaleClassCode 'New'
                xml.CustomerProspect do
                  xml.ProspectParty do
                    xml.PartyID @variables[:party_id]
                  end
                end
                xml.DocumentationIdentificationGroup do
                  xml.DocumentationIdentification do
                    xml.DocumentID @variables[:event_id]
                  end
                end
                xml.LeadPreference do
                  xml.PriorityRankingNumeric '1'
                end
                xml.ProviderParty do
                  xml.PartyID 'T2Modus'
                end
              end
            end
          end
        end
      end.to_xml
    end
  end
end
