class User < ActiveRecord::Base
  has_secure_password

  has_many :logs, dependent: :destroy
  has_many :tracks, through: :logs

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
  validates :distance_units, inclusion: { in: [:imperial, :metric] }, unless: ->(s) { s.blank? }

  attr_protected :is_admin

  def display_name
    self.name.blank? ? self.username : self.name
  end

  def distance_units
    attributes["distance_units"].try(:to_sym) || Tracklog::Config.distance_units
  end
end
