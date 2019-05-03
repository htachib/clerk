class Parser < ActiveRecord::Base
  belongs_to :user
  has_many :documents, dependent: :destroy

  scope :active, -> { where.not(destination_id: nil) }

  validates_presence_of :destination_id
  validates_uniqueness_of :external_id, scope: :user_id
end
