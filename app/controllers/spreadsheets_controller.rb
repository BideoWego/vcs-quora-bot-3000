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
      flash[:error] = 'Spreadsheet not linked'
      render :new
    end
  end

  def update
    if @spreadsheet.update(spreadsheet_params)
      flash[:success] = 'Spreadsheet updated'
      redirect_to spreadsheet_path(@spreadsheet)
    else
      flash[:error] = 'Spreadsheet not updated'
      render :edit
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
end
