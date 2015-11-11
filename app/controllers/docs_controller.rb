class DocsController < ApplicationController

  def index
    @doc = Doc.new(
      :key => "1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc",
      :worksheet => 0
    )
    
    @quora_links = @doc.spreadsheet_range(
      10..@doc.spreadsheet.num_rows-1,
      3..3
    ).reject{ |el| el[0].empty? }

    # Uncomment below to see ALL rows and columns
    # @quora_links = @doc.spreadsheet_range(
    #   1..@doc.spreadsheet.num_rows,
    #   1..@doc.spreadsheet.num_cols
    # )
  end

end