class Parser < ActiveRecord::Base
  belongs_to :user
  has_many :documents, dependent: :destroy
  has_many :parse_map_exceptions, dependent: :destroy

  scope :active, -> { where.not(destination_id: nil) }

  serialize :settings, Hash

  validates_presence_of :destination_id
  validates_uniqueness_of :external_id, scope: :user_id
end
