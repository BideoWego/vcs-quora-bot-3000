Rails.application.routes.draw do
  resources :spreadsheets
  root 'spreadsheets#index'
end