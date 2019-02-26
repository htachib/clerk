class Parser < ActiveRecord::Base
  belongs_to :user
  has_many :documents, dependent: :destroy

  validates_presence_of :destination_id
end
