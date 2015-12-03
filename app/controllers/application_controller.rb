class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected
  def require_credentials
    unless Setting.client_credentials? && Setting.access_token?
      redirect_to settings_path, :flash => {:error => 'Client ID, Client Secret and Access Token must be preset once there are existing spreadsheets and scrapes!'}
    end
  end
end
