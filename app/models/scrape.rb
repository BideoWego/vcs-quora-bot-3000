class Scrape < ActiveRecord::Base
  belongs_to :spreadsheet
  serialize :data, JSON

  before_save :do_scrape


  private
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
