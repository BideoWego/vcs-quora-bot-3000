class DocsController < ApplicationController

  def index
    if params[:code]
      @doc = Doc.new(
        :key => "1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc",
        :worksheet => 0,
        :token => params[:code]
      )

      @doc.create_session

      @quora_links = @doc.spreadsheet_range(
        10..@doc.spreadsheet.num_rows-1,
        3..3
      ).reject{ |el| el[0].empty? }

      # Uncomment below to see ALL rows and columns
      @quora_links = @doc.spreadsheet_range(
        1..@doc.spreadsheet.num_rows,
        1..@doc.spreadsheet.num_cols
      )
    else
      @doc = Doc.new
    end
    @code = params[:code]
  end

  def redirect
    redirect_to root_path
  end

end