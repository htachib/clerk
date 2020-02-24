class Parser < ActiveRecord::Base
  include Libraryable

  belongs_to :user
  has_many :documents, dependent: :destroy
  has_many :parse_map_exceptions, dependent: :destroy

  scope :active, -> { where is_active: true }
  scope :inactive, -> { where is_active: false }

  serialize :settings, Hash

  validates_presence_of :destination_id
  validates_uniqueness_of :external_id, scope: :user_id

  def last_processed_document
    documents.processed.order(updated_at: :desc).first
  end
end
