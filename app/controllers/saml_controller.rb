class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:consume, :logout]

  def sso_account_verification
    unless params[:email].present?
      redirect_to root_path
      return
    end

    account = Account.find_by email: params[:email]
    if account
      settings = account.get_saml_settings
      if settings.nil?
        render :action => :no_settings
        return
      end

      request = OneLogin::RubySaml::Authrequest.new
      redirect_to(request.create(settings, RelayState: 1234567))
    else
      # to do show flash message
      redirect_to root_path
    end
  end

  def consume
    settings = Account.get_saml_settings
    if settings.nil?
      render :action => :no_settings
      return
    end
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], skip_recipient_check: true)
    response.settings = settings

    if response.is_valid?
      # sign in or sign up here
      # render :action => :index
      # sign_in
      user = User.find_by email: response.attributes["email"]
      if !user
        user = User.create email: response.attributes["email"], password: Devise.friendly_token[0,20]
      end

      sign_in(user)

      # binding.pry

      redirect_to root_path
    else
      logger.info "Response Invalid. Errors: #{response.errors}"
      @errors = response.errors
      render :action => :fail
    end
    # binding.pry
  end

  def metadata
    settings = Account.get_saml_settings
    meta = OneLogin::RubySaml::Metadata.new
    render xml: meta.generate(settings, true)
  end
end
