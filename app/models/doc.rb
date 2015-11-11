# ------------------------------------
# Not set in stone
# ------------------------------------
# 
# It's good to wrap these functionality in a 
# model
# 
# However the structure of this can
# and probably should change (method names etc...)
# Why?
# 
# Eventually we should think about how we can "talk"
# to a Doc as if it were a spreadsheet
# 
# For now we must call @doc.spreadsheet
# 
# Perhaps even change the name to Spreadsheet to
# be more specific in can we want to support
# multiple document types
# 

class Doc
  include ActiveModel::Model

  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']
  SCOPE = "https://www.googleapis.com/auth/drive " +
          "https://spreadsheets.google.com/feeds/"
  REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob"

  attr_accessor :spreadsheet,
                :key,
                :worksheet

  def initialize(attributes={})
    super
    initialize_api
    authorize_api
    create_api_session
    initialize_attributes(attributes)
  end

  # Get a spreadsheet given a key and worksheet
  def spreadsheet_by_key_index(key, worksheet)
    @session.spreadsheet_by_key(key).worksheets[worksheet]
  end

  # Get a range of a given spreadsheet
  # Set the start/end rows in row_range
  # Set the start/end columns in col_range
  def spreadsheet_range(row_range, col_range)
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


  private
  def initialize_api
    @client = Google::APIClient.new
  end

  def authorize_api
    @auth = @client.authorization
    @auth.client_id = CLIENT_ID
    @auth.client_secret = CLIENT_SECRET
    @auth.scope = SCOPE
    @auth.redirect_uri = REDIRECT_URI
  end

  def create_api_session
    @session = GoogleDrive.saved_session()
  end

  # Initialize doc with @spreadsheet
  # if attributes given
  def initialize_attributes(attributes)
    unless attributes.keys.empty?
      @spreadsheet = spreadsheet_by_key_index(
        attributes[:key],
        attributes[:worksheet]
      )
    end
  end
end




