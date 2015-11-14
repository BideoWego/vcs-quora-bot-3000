class Spreadsheet < ActiveRecord::Base
  has_many :scrapes

  after_initialize :create_internal_spreadsheet

  validates :key,
            :presence => true,
            :uniqueness => true

  validate :create_internal_spreadsheet

  # Thank you: http://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149
  URL_REGEX = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/

  attr_accessor :internal_spreadsheet

  # Same method that was in Doc
  # namespaced better under a Spreadsheet class
  def range(row_range, col_range)
    range = []
    row_range.each do |row|
      range_row = []
      col_range.each do |col|
        range_row << data_worksheet[row, col]
      end
      range << range_row
    end
    range
  end

  # Forwards any missing methods
  # to the @internal_spreadsheet object
  # only if it responds to the method
  def method_missing(name, *args)
    if @internal_spreadsheet.respond_to?(name)
      args.length > 0 ? @internal_spreadsheet.send(name, args) : @internal_spreadsheet.send(name)
    else
      raise NoMethodError, "Undefined method #{name} for Spreadsheet"
    end
  end

  # Getter for data worksheet
  # (Sheet with analytics)
  def data_worksheet
    @data_worksheet = @internal_spreadsheet.worksheet_by_gid(data_gid) unless @data_worksheet
    @data_worksheet
  end

  # Getter for map worksheet
  # (Sheet with named range map)
  def map_worksheet
    @map_worksheet = @internal_spreadsheet.worksheet_by_gid(map_gid) unless @map_worksheet
    @map_worksheet
  end

  # Generate list of URLs
  def generate_urls
  	urls_col = index_from_col_letter(self.map_worksheet[2,2])
  	urls_row = self.map_worksheet[2,3]
  	all_urls = self.range((urls_row.to_i..self.data_worksheet.num_rows).to_a, (urls_col..urls_col).to_a)
  	# Ensure that we only have URLs in our all_urls value
  	all_urls.reject!{ |x| !x[0].match(URL_REGEX) }.flatten
  end

  # Upload
  def upload(scrape_id)
    scrape = self.scrapes.find_by_id(scrape_id)
    current_row = self.map_worksheet[2,3].to_i
    scrape.data.each do |key, value|
      remote_url = self.data_worksheet[current_row,3]
      if key == remote_url
        self.data_worksheet[current_row,index_from_col_letter('e')] = scrape.data[key]['last_asked_date']
        self.data_worksheet[current_row,index_from_col_letter('f')] = scrape.data[key]['view_count']
        self.data_worksheet[current_row,index_from_col_letter('g')] = scrape.data[key]['follower_count']
        self.data_worksheet[current_row,index_from_col_letter('h')] = scrape.data[key]['answer_count']
        self.data_worksheet[current_row,index_from_col_letter('j')] = scrape.data[key]['upvote_count']
        self.data_worksheet[current_row,index_from_col_letter('k')] = scrape.data[key]['viking_answer_date']
      end
      current_row += 1
    end
    self.data_worksheet.save
  end


  private
  # Used as an after_initialize callback
  # and validation callback
  # 
  # Creates an internal spreadsheet from API
  # If creation is unsuccessful
  # it appends the API's exception message
  # as a validation error to the model
  # instance
  def create_internal_spreadsheet
    begin
      @internal_spreadsheet = GoogleDriveAPI.session
        .spreadsheet_by_key(key) if key && key.chars.present?
    rescue Google::APIClient::ClientError, GoogleDrive::Error => e
      self.errors.add(:key, " raised a Google API error - #{e.message}")
    end
  end

  # Get index from column letter
  def index_from_col_letter(letter)
  	letters_array = ('a'..'z').to_a
  	letters_array.index(letter.downcase) + 1
  end
end
