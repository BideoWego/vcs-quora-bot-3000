class ScrapesController < ApplicationController
  before_action :set_scrape, :only => [:show, :destroy]

  def index
    @scrapes = Scrape.order(:created_at => 'DESC')
  end

  def show
  end

  def new
    @scrape = Scrape.new
  end

  def create
    @scrape = Scrape.new(scrape_params)
    if @scrape.save
      flash[:success] = 'Scrape created'
      redirect_to @scrape
    else
      flash[:error] = 'Scrape not created'
      render :new
    end
  end

  def destroy
    if @scrape.destroy
      flash[:success] = 'Scrape destroyed'
    else
      flash[:error] = 'Scrape not destroyed'
    end
    redirect_to scrapes_path
  end


  private
  def set_scrape
    @scrape = Scrape.find_by_id(params[:id])
  end

  def scrape_params
    params.require(:scrape)
      .permit(
        :spreadsheet_id
      )
  end
end
