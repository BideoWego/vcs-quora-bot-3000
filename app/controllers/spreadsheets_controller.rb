class SpreadsheetsController < ApplicationController
  def index
    # Perhaps this values could eventually go in a form?
    @spreadsheet = Spreadsheet.find_by_key_worksheet(
      "1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc",
      0
    )
    
    @spreadsheet_range = @spreadsheet.range(
      10..@spreadsheet.num_rows,
      3..3
    ).reject{ |el| el[0].empty? }

    # @spreadsheet_range = @spreadsheet.range(
    #   1..@spreadsheet.num_rows,
    #   1..@spreadsheet.num_cols
    # )
  end
end
