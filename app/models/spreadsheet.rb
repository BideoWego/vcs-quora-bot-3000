class Spreadsheet < ActiveRecord::Base
  has_many :scrapes, :dependent => :destroy

  after_initialize :create_internal_spreadsheet
  after_initialize :populate_attributes

  validates :key,
            :presence => true,
            :uniqueness => true

  validate :create_internal_spreadsheet

  attr_accessor :internal_spreadsheet,
                :data_worksheet,
                :map_worksheet

  def refresh
    populate_attributes
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

  # Generate list of URLs
  def generate_urls
    @data_worksheet.sanitized_urls
  end

  # Upload
  def upload(scrape_id)
    scrape = self.scrapes.find_by_id(scrape_id)
    @data_worksheet.write(scrape.data)
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
      GoogleDriveAPI.init
      @internal_spreadsheet = GoogleDriveAPI.session
        .spreadsheet_by_key(key) if key && key.chars.present?
    rescue Google::APIClient::ClientError, GoogleDrive::Error, StandardError => e
      self.errors.add(:key, " raised a Google API error - #{e.message}")
    end
  end

  def populate_attributes
    if @internal_spreadsheet
      @map_worksheet = MapWorksheet.new(
        :worksheet => @internal_spreadsheet.worksheet_by_gid(map_gid),
        :spreadsheet => self
      ) if map_gid

      if data_gid
        @data_worksheet = DataWorksheet.new(
          :worksheet => @internal_spreadsheet.worksheet_by_gid(data_gid),
          :spreadsheet => self
        )
        @data_worksheet.create_named_ranges(@map_worksheet)
      end
    end
  end
end


