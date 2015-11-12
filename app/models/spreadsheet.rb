class Spreadsheet
  include ActiveModel::Model

  attr_accessor :key,
                :worksheet,
                :spreadsheet

  def initialize(attributes={})
    # This should take the given attributes
    # and map them into a valid Spreadsheet object
    # 
    # For the moment it relies on being
    # passed a :key, :worksheet, and :spreadsheet
    # that all correspond
    attributes.each {|key, value| self.send("#{key}=", value)}
  end

  # Same method that was in Doc
  # namespaced better under a Spreadsheet class
  def range(row_range, col_range)
    range = []
    row_range.each do |row|
      range_row = []
      col_range.each do |col|
        range_row << @spreadsheet[row, col]
      end
      range << range_row
    end
    range
  end

  # Forwards any missing methods
  # to the @spreadsheet object
  # only if it responds to the method
  def method_missing(name, *args)
    p name
    if @spreadsheet.respond_to?(name)
      args.length > 0 ? @spreadsheet.send(name, args) : @spreadsheet.send(name)
    else
      raise NoMethodError, "Undefined method #{name} for Spreadsheet"
    end
  end

  # Altered method from Doc (now a factory method)
  # Queries the GoogleDriveAPI for a worksheet
  # Then returns a new Spreadsheet instance from it
  def self.find_by_key_worksheet(key, worksheet)
    spreadsheet = GoogleDriveAPI.session
      .spreadsheet_by_key(key)
      .worksheets[worksheet]
    Spreadsheet.new(
      :spreadsheet => spreadsheet,
      :key => key,
      :worksheet => worksheet
    )
  end
end
