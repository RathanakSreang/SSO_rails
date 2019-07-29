class Account < ApplicationRecord
  def self.get_saml_settings
    testing = self.first
    idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    settings = idp_metadata_parser.parse(testing.content)
    settings
  end

  def get_saml_settings
    idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    settings = idp_metadata_parser.parse(self.content)
    settings
  end
end
