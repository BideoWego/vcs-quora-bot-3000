class Scrape < ActiveRecord::Base
  belongs_to :spreadsheet
  serialize :data, JSON
end
