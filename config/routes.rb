Rails.application.routes.draw do
  resources :accounts
  root "static#home"
  post :sso_account_verification, to: "saml#sso_account_verification", as: :sso_account_verification
  # post :consume
  post "auth/sso/callback", to: "saml#consume"
  devise_for :users

  # post "auth/okta/callback", to: "static#okta"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
