class SpreadsheetsController < ApplicationController
  before_action :set_spreadsheet, :only => [:show, :edit, :update, :destroy]

  def index
    @spreadsheets = Spreadsheet.all
  end

  def show
  end

  def new
    @spreadsheet = Spreadsheet.new
  end

  def edit
  end

  def create
    @spreadsheet = Spreadsheet.new(spreadsheet_params)
    if @spreadsheet.save
      flash[:success] = 'Spreadsheet linked'
      redirect_to spreadsheets_path
    else
      flash.now[:error] = 'Spreadsheet not linked'
      render :new
    end
  end

  def update
    if params[:scrape_id]
      upload_scrape_data_to_spreadsheet
    else
      update_spreadsheet_reference
    end
  end

  def destroy
    if @spreadsheet.destroy
      flash[:success] = 'Spreadsheet reference destroyed'
    else
      flash[:error] = 'Spreadsheet reference not destroyed'
    end
    redirect_to spreadsheets_path
  end


private
  def set_spreadsheet
    @spreadsheet = Spreadsheet.find_by_id(params[:id])
  end

  def spreadsheet_params
    params.require(:spreadsheet)
      .permit(
        :key,
        :data_gid,
        :map_gid
      )
  end

  def upload_scrape_data_to_spreadsheet
    if @spreadsheet.upload(params[:scrape_id])
      flash[:success] = 'Scrape data uploaded'
    else
      flash[:error] = 'Scrape data not uploaded'
    end
    redirect_to scrapes_path
  end

  def update_spreadsheet_reference
    if @spreadsheet.update(spreadsheet_params)
      flash[:success] = 'Spreadsheet updated'
      redirect_to spreadsheet_path(@spreadsheet)
    else
      flash[:error] = 'Spreadsheet not updated'
      render :edit
    end
  end
end



