class GoogleDriveAPI

  # Google API Config Variables
  APP_NAME = ENV['APP_NAME']
  APP_VERSION = ENV['APP_VERSION']
  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']
  SCOPE = "https://www.googleapis.com/auth/drive " +
          "https://spreadsheets.google.com/feeds/"
  REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob"

  # Class attributes
  @@client = nil
  @@auth = nil
  @@session = nil

  # Session getter
  def self.session
    init # <<< always calls init
    @@session
  end

  private
  def self.init
    # However init only inits if not already
    # initialized
    create_client unless @@client
    create_auth unless @auth
    create_session unless @@session
  end

  # Set up the GoogeDrive gem client
  def self.create_client
    @@client = Google::APIClient.new(
      :application_name => APP_NAME,
      :application_version => APP_VERSION
    )
  end

  # auth
  def self.create_auth
    @@auth = @@client.authorization
    @@auth.client_id = CLIENT_ID
    @@auth.client_secret = CLIENT_SECRET
    @@auth.scope = SCOPE
    @@auth.redirect_uri = REDIRECT_URI
    @@auth.refresh_token = ENV["DRIVE_TOKEN_DATA"]
    @@auth.fetch_access_token!
  end

  # and session
  def self.create_session
    @@session = GoogleDrive.login_with_oauth(@@client)
  end
end
