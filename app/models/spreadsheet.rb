class Spreadsheet < ActiveRecord::Base
  has_many :scrapes, :dependent => :destroy

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
    self.data_worksheet.range(row_range, col_range)
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
    @data_worksheet = DataWorksheet.new(
      :worksheet => @internal_spreadsheet.worksheet_by_gid(data_gid),
      :spreadsheet => self
    ) unless @data_worksheet
    @data_worksheet
  end

  # Getter for map worksheet
  # (Sheet with named range map)
  def map_worksheet
    @map_worksheet = MapWorksheet.new(
      :worksheet => @internal_spreadsheet.worksheet_by_gid(map_gid),
      :spreadsheet => self
    ) unless @map_worksheet
    @map_worksheet
  end

  # Generate list of URLs
  def generate_urls
  	urls_col = self.map_worksheet[2, 'b']
  	urls_row = self.map_worksheet[2, 'c']
    row_range = urls_row.to_i..self.data_worksheet.num_rows
    col_range = urls_col..urls_col
    all_urls = self.range(row_range, col_range)
  	# Ensure that we only have URLs in our all_urls value
  	all_urls.reject!{ |x| !x[0].match(URL_REGEX) }.flatten
  end

  # Upload
  def upload(scrape_id)
    scrape = self.scrapes.find_by_id(scrape_id)
    current_row = self.map_worksheet[2, 'c'].to_i
    scrape.data.each do |key, value|
      remote_url = self.data_worksheet[current_row, 'c']
      if key == remote_url
        self.data_worksheet[current_row, 'e'] = scrape.data[key]['last_asked_date']
        self.data_worksheet[current_row, 'f'] = scrape.data[key]['view_count']
        self.data_worksheet[current_row, 'g'] = scrape.data[key]['follower_count']
        self.data_worksheet[current_row, 'h'] = scrape.data[key]['answer_count']
        self.data_worksheet[current_row, 'j'] = scrape.data[key]['upvote_count']
        self.data_worksheet[current_row, 'k'] = scrape.data[key]['viking_answer_date']
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

  # Get index from column letters
  def index_from_col_letter(letters)
    Worksheet.col_index_for(letters)
  end
end


