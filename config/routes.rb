Rails.application.routes.draw do
  resources :spreadsheets
  resources :scrapes, :except => [:edit, :update]
  root 'spreadsheets#index'
end