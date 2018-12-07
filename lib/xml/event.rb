# frozen_string_literal: true

module XML
  # This class dynamically builds event/opportunity xml to send to dealersocket
  class Event < Base
    def create
      build_xml do |xml|
        xml.adf do
          xml.prospect do
            xml.id('source' => 'T2modus.com', 'sequence' => '1') { xml.text '1494077439' }
            xml.requestdate Time.current
            create_vehicle(xml)
            create_customer(xml)
            xml.vendor do
              xml.vendorname @variables[:vendorname]
            end
            xml.provider do
              xml.name('part' => 'full') { xml.text 'T2modus.com' }
              xml.email 'support@t2modus.com'
              xml.contact do
                xml.name('part' => 'full') { xml.text 'T2 Modus' }
                xml.email 'support@t2modus.com'
              end
            end
          end
        end
      end
    end

    def update
      build_xml do |xml|
        xml.ProcessSalesLead(default_namespace_hash) do
          application_area(xml, 'XXXXXX')
          xml.ProcessSalesLeadDataArea do
            xml.SalesLead do
              sales_detail(xml)
              sales_header(xml)
            end
          end
        end
      end
    end

    private

    def create_customer(xml)
      xml.customer do
        xml.contact do
          xml.name('part' => 'first') { xml.text @variables[:given_name] }
          xml.name('part' => 'last') { xml.text @variables[:family_name] }
          xml.email @variables[:uriid]
          xml.phone('type' => 'voice', 'time' => 'evening') { xml.text @variables[:phone] }
          xml.address do
            xml.street('line' => '1') { xml.text @variables[:line_one] }
            xml.street('line' => '2') { xml.text @variables[:line_two] }
            xml.city @variables[:city_name]
            xml.regioncode @variables[:state]
            xml.postalcode @variables[:postcode]
          end
        end
      end
    end

    def create_vehicle(xml)
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
    end

    def sales_header(xml)
      xml.SalesLeadHeader do
        xml.LeadComments
        xml.LeadInterestCode 'B'
        xml.SaleClassCode 'New'
        xml.CustomerProspect do
          xml.ProspectParty do
            xml.PartyID @variables[:customer_id]
          end
        end
        xml.DocumentIdentificationGroup do
          xml.DocumentIdentification do
            xml.DocumentID @variables[:id]
          end
        end
        xml.LeadPreference do
          # 1=Hot, 2=Medium, 3=Cold
          xml.PriorityRankingNumeric @variables[:priority_ranking]
        end
        xml.ProviderParty do
          xml.PartyID @variables[:provider_party_id]
        end
      end
    end

    def sales_detail(xml)
      xml.SalesLeadDetail do
        xml.LeadStatus 'Contacted'
        xml.SalesActivity do
          xml.SalesPersonName
          xml.Vehicle do
            xml.ManufacturerName @variables[:make]
            xml.ModelDescription @variables[:model]
            xml.ModelYear @variables[:year]
            xml.VehicleID @variables[:vin]
            xml.VehicleNote @variables[:vehicle_note]
            xml.VehicleStockString
          end
        end
      end
    end
  end
end
