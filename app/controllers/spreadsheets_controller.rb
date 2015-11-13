class SpreadsheetsController < ApplicationController
  def index
    # Perhaps this values could eventually go in a form?
    # @spreadsheet = Spreadsheet.find_by_key_worksheet(
    #   "1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc",
    #   0
    # )
    
    # @spreadsheet_range = @spreadsheet.range(
    #   10..@spreadsheet.num_rows-1,
    #   3..3
    # ).reject{ |el| el[0].empty? }

    # @spreadsheet_range = @spreadsheet.range(
    #   1..@spreadsheet.num_rows,
    #   1..@spreadsheet.num_cols
    # )

    # @spreadsheet_range.each do |link|
    #   @quora_task = QuoraTask.new(link[0])
    #   answer_count = @quora_task.get_answer_count
    #   view_count = @quora_task.get_view_count
    #   follower_count = @quora_task.get_follower_count
    #   last_asked_date = @quora_task.get_last_asked_date
    #   upvote_count = @quora_task.get_upvote_count
    #   link.push(answer_count).push(view_count).push(follower_count).push(last_asked_date).push(upvote_count)
    end
  end
end
