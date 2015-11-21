Rails.application.routes.draw do
  resources :spreadsheets
  get "setup" => "setup#setup"
  resources :scrapes, :except => [:edit, :update] do
    resources :spreadsheets, :only => [:update]
  end
  root 'spreadsheets#index'
end