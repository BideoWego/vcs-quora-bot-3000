Rails.application.routes.draw do
  root 'docs#index'
  get '/google-docs-redirect', :to => 'docs#redirect'

  resources :docs

end