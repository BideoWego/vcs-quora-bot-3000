class Scrape < ActiveRecord::Base
  belongs_to :spreadsheet
  serialize :data, JSON

  validate  :spreadsheet_has_data_worksheet,
            :spreadsheet_has_map_worksheet

  before_save :do_scrape


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

  def do_scrape
    data = {}
    temp_spreadsheet = Spreadsheet.find(self.spreadsheet_id)
    all_urls = temp_spreadsheet.generate_urls
    total = all_urls.length
    all_urls.each_with_index do |quora_url, i|
      puts "Scraping #{i + 1} of #{total} urls"
    	data[quora_url] = QuoraTask.new(quora_url).scrape
    end
    self.data = data
  end
end
