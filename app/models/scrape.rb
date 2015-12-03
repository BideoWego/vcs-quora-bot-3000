class Scrape < ActiveRecord::Base
  belongs_to :spreadsheet
  serialize :data, JSON

  validate  :spreadsheet_exists,
            :spreadsheet_has_data_worksheet,
            :spreadsheet_has_map_worksheet


  private
  def spreadsheet_exists
    unless Spreadsheet.find_by_id(self.spreadsheet_id)
      errors.add(:spreadsheet, 'must exist')
    end
  end

  def spreadsheet_has_data_worksheet
    spreadsheet = Spreadsheet.find_by_id(self.spreadsheet_id)
    unless spreadsheet && spreadsheet.data_gid
      errors.add(:spreadsheet, 'must have a data worksheet set')
    end
  end

  def spreadsheet_has_map_worksheet
    spreadsheet = Spreadsheet.find_by_id(self.spreadsheet_id)
    unless spreadsheet && spreadsheet.map_gid
      errors.add(:spreadsheet, 'must have a map worksheet set')
    end
  end
end