Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'check_session', to: 'check_session#check'
  get 'address_helper/:uf/:city/:address', to: 'contacts#address_helper'

  resources :contacts
end
