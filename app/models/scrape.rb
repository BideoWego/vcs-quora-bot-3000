class Scrape < ActiveRecord::Base
  belongs_to :spreadsheet
  serialize :data, JSON

  validate  :spreadsheet_has_data_worksheet,
            :spreadsheet_has_map_worksheet


  private
  def spreadsheet_has_data_worksheet
    unless Spreadsheet.find(self.spreadsheet_id).data_gid
      errors.add(:spreadsheet, 'must have a data worksheet set')
    end
  end

  def spreadsheet_has_map_worksheet
    unless Spreadsheet.find(self.spreadsheet_id).map_gid
      errors.add(:spreadsheet, 'must have a map worksheet set')
    end
  end

end