class Setting < ActiveRecord::Base
  validates :key,
            :presence => true,
            :uniqueness => true

  validates :value,
            :presence => true

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
end
