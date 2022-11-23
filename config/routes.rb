Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'sign_into_newsletter', to: 'newsletter_emails#sign_into_newsletter'

  resources :movies, only: %i[index create]
end
