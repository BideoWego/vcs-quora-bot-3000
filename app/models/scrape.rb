class Scrape < ActiveRecord::Base
  belongs_to :spreadsheet
  serialize :data, JSON

  after_save :do_scrape


  private
  def do_scrape
    data = {}
    all_urls = self.spreadsheet.generate_urls
    # iterate urls
    # append to data
    # set data on model
    all_urls.each do |quora_url|
    	data[quora_url] = QuoraTask.new(quora_url).scrape
    end
    self.data = data
    binding.pry
  end
end
