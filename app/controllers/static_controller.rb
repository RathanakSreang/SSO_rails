class StaticController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:okta]
  def home
  end

  def okta
    binding.pry
    # params[:RelayState]
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    settings = Account.get_saml_settings
    response.settings = settings
    if response.is_valid?
    else
      logger.info "Response Invalid. Errors: #{response.errors}"
      @errors = response.errors
      render :action => :fail
    end
    # binding.pry
  end
end
