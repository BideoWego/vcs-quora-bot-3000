class SettingsController < ApplicationController
  before_action :set_setting, :only => [:update, :destroy]

  def index
    @app_name = Setting.key(:app_name)
    @app_version = Setting.key(:app_version)
    @client_id = Setting.key(:client_id)
    @client_secret = Setting.key(:client_secret)
    @redirect_token = Setting.key(:redirect_token)
    @access_token = Setting.key(:access_token)
  end

  def create
    @setting = Setting.new(setting_params)
    if @setting.save
      flash[:success] = 'Setting created'
    else
      flash[:error] = 'Setting not created'
    end
    redirect_to request.referer ? request.referer : settings_path
  end

  def update
    if @setting.update(setting_params)
      flash[:success] = 'Setting updated'
    else
      flash[:error] = 'Setting not updated'
    end
    redirect_to settings_path
  end

  def destroy
    if @setting.destroy
      flash[:success] = 'Setting destroyed'
    else
      flash[:error] = 'Setting not destroyed'
    end
    redirect_to settings_path
  end


  private
  def set_setting
    @setting = Setting.find_by_id(params[:id])
  end

  def setting_params
    params.require(:setting)
      .permit(
        :key,
        :value
      )
  end
end
