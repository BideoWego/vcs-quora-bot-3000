class SetupController < ApplicationController
  def index
    if GoogleDriveAPI.authorizable?
      initialize_google_drive_api
      if GoogleDriveAPI.access_token_fetchable?
        save_access_token
      elsif GoogleDriveAPI.without_tokens?
        @authorization_uri = URI.parse(GoogleDriveAPI.auth.authorization_uri).to_s
        @redirect_token = Setting.key(:redirect_token)
      else
        @access_token = Setting.key(:access_token)
      end
    end
  end


  private
  def initialize_google_drive_api
    GoogleDriveAPI.create_client
    GoogleDriveAPI.create_auth
    GoogleDriveAPI.authorize
    GoogleDriveAPI.create_auth_url
  end

  def save_access_token
    GoogleDriveAPI.auth.code = Setting.key(:redirect_token).value
    @access_token = GoogleDriveAPI.fetch_access_token['refresh_token']
    setting_params = {
      :key => :access_token,
      :value => @access_token
    }
    if Setting.create(setting_params)
      flash.now[:success] = 'Access token saved'
    else
      flash.now[:error] = 'Access token not saved'
    end
  end
end

