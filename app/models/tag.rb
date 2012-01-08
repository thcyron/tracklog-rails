class Tag < ActiveRecord::Base
  has_and_belongs_to_many :logs
  validates :name, presence: true, uniqueness: true
  before_save :normalize

  def to_param
    self.name
  end

  def self.normalize_name(name)
    UnicodeUtils.downcase(UnicodeUtils.nfkd(name))
  end

  def normalize
    self.name = Tag.normalize_name(self.name)
  end
end
