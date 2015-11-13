class Spreadsheet < ActiveRecord::Base
  after_initialize :create_internal_spreadsheet

  validates :key,
            :presence => true,
            :uniqueness => true

  validate :create_internal_spreadsheet

  attr_accessor :internal_spreadsheet

  # Same method that was in Doc
  # namespaced better under a Spreadsheet class
  def range(row_range, col_range)
    range = []
    row_range.each do |row|
      range_row = []
      col_range.each do |col|
        range_row << @internal_spreadsheet[row, col]
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

  def data_worksheet
    @internal_spreadsheet.worksheet_by_gid(data_gid)
  end

  def map_worksheet
    @internal_spreadsheet.worksheet_by_gid(map_gid)
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
end
