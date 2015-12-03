class GoogleDriveAPI
  SCOPE = [
    "https://www.googleapis.com/auth/drive",
    "https://spreadsheets.google.com/feeds/"
  ].join(' ')
  REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob"

  # Class attributes
  @@client = nil
  @@auth = nil
  @@session = nil

  # Session getter
  def self.session
    @@session
  end

  def self.auth
    @@auth
  end

  private
  def self.init
    create_client
    create_auth
    authorize
    create_auth_url
    fetch_access_token
    create_session
  end

  # Set up the GoogeDrive gem client
  def self.create_client
    @@client = Google::APIClient.new(
      :application_name => Setting.key(:app_name).value,
      :application_version => Setting.key(:app_version).value
    )
  end

  # auth
  def self.create_auth
    @@auth = @@client.authorization
  end

  def self.authorize
    @@auth.client_id = Setting.key(:client_id).value
    @@auth.client_secret = Setting.key(:client_secret).value
  end

  def self.create_auth_url
    @@auth.scope = SCOPE
    @@auth.redirect_uri = REDIRECT_URI
  end

  def self.fetch_access_token
    @@auth.refresh_token = Setting.key(:access_token).value
    @@auth.fetch_access_token!
  end

  # and session
  def self.create_session
    @@session = GoogleDrive.login_with_oauth(@@client)
  end

  def self.authorizable?
    Setting.client_credentials?
  end

  def self.access_token_fetchable?
    Setting.redirect_token? && !Setting.access_token?
  end

  def self.without_tokens?
    !Setting.redirect_token? && !Setting.access_token?
  end
end


