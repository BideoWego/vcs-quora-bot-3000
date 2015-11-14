class Scrape < ActiveRecord::Base
  belongs_to :spreadsheet
  serialize :data, JSON

  after_initialize :do_scrape


  private
  def do_scrape
    data = {}
    # iterate urls
    # append to data
    # set data on model
    self.data = QuoraTask.new(
      'https://www.quora.com/What-online-code-bootcamps-will-emerge-on-top-in-1-2-years-Why'
    ).scrape
  end
end
