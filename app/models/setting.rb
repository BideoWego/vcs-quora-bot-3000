class Setting < ActiveRecord::Base
  validates :key,
            :presence => true,
            :uniqueness => true

  validates :value,
            :presence => true

  before_destroy :deny_if_required

  def self.key(key)
    Setting.find_by_key(key) || Setting.new(:key => key)
  end

  def self.client_credentials?
    Setting.key(:client_id).persisted? &&
    Setting.key(:client_secret).persisted?
  end

  def self.redirect_token?
    Setting.key(:redirect_token).persisted?
  end

  def self.access_token?
    Setting.key(:access_token).persisted?
  end


  private
  def deny_if_required
    if [:client_id, :client_secret, :access_token].include?(key.to_sym) && Spreadsheet.count > 0
      errors.add(:base, "Cannot delete required credentials with existing spreadsheets")
    end
    errors.empty?
  end
end

