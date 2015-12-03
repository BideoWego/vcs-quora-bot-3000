Rails.application.routes.draw do
  resources :spreadsheets
  resources :scrapes, :except => [:edit, :update] do
    resources :spreadsheets, :only => [:update]
  end
  resources :settings, :except => [:new, :show, :edit]
  get 'setup', :to => 'setup#index'
  root 'setup#index'
end

