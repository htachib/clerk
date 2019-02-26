class Parser < ActiveRecord::Base
  belongs_to :user
  has_many :documents
end
