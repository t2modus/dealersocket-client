# frozen_string_literal: true

module XML
  # This class dynamically builds customer xml to send to dealersocket
  class Customer < Base
    def find
      build_xml do |xml|
        xml.GetCustomerInformation(default_namespace_hash) do
          application_area(xml, 'Customer')
          customer_information_fields(xml) do
            xml.PartyID @variables[:id]
          end
        end
      end
    end

    def search
      build_xml do |xml|
        xml.GetCustomerInformation(default_namespace_hash) do
          application_area(xml, 'Customer')
          customer_information_fields(xml) do
            xml.SpecifiedPerson do
              xml.FamilyName @variables[:family_name] if @variables[:family_name].present?
              xml.GivenName @variables[:given_name] if @variables[:given_name].present?
              if @variables[:uriid].present?
                xml.URICommunication do
                  xml.ChannelCode 'Email Address'
                  xml.URIID @variables[:uriid]
                end
              end
              if @variables[:phone].present?
                xml.TelephoneCommunication do
                  xml.CompleteNumber @variables[:phone]
                end
              end
            end
          end
        end
      end
    end

    def create_or_update
      build_xml do |xml|
        xml.ProcessCustomerInformation(default_namespace_hash) do
          application_area(xml, 'Customer')
          xml.ProcessCustomerInformationDataArea do
            xml.CustomerInformation do
              xml.CustomerInformationHeader do
                xml.TransactionTypeCode @variables[:transaction_type_code]
              end
              xml.CustomerInformationDetail do
                xml.CustomerParty do
                  xml.SpecifiedPerson do
                    name_xml(xml)
                    address_xml(xml)
                    phones_xml(xml)
                    email_xml(xml)
                    xml.ContactMethodTypeCode 'Email'
                    xml.LanguageCode 'English'
                  end
                end
              end
            end
          end
        end
      end
    end

    private

    def address_xml(xml)
      xml.ResidenceAddress do
        {
          'LineOne' => :line_one,
          'CityName' => :city_name,
          'Postcode' => :postcode,
          'StateOrProvinceCountrySub-DivisionID' => :state
        }.each do |xml_key, variable_key|
          xml.send(xml_key, @variables[variable_key]) if @variables[variable_key].present?
        end
        xml.Privacy do
          xml.PrivacyIndicator @variables[:privacy_indicator]
        end
      end
    end

    def customer_information_fields(xml)
      xml.GetCustomerInformationDataArea do
        xml.CustomerInformation do
          xml.CustomerInformationDetail do
            xml.CustomerParty do
              yield
            end
          end
        end
      end
    end

    def email_xml(xml)
      return if @variables[:uriid].blank?
      xml.URICommunication do
        xml.URIID @variables[:uriid]
        xml.Privacy do
          xml.PrivacyIndicator @variables[:privacy_indicator]
        end
      end
    end

    def name_xml(xml)
      { 'ID' => :id, 'GivenName' => :given_name, 'FamilyName' => :family_name }.each do |xml_key, variable_key|
        xml.send(xml_key, @variables[variable_key]) if @variables[variable_key].present?
      end
    end

    def phones_xml(xml)
      %i[home cell work].each do |phone|
        next if @variables[phone].blank?
        xml.TelephoneCommunication do
          xml.CompleteNumber @variables[phone]
          xml.UseCode phone.to_s.capitalize
        end
      end
    end
  end
end
