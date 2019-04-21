class User < ActiveRecord::Base
  ADMIN_EMAIL = 'admin@clerkocr.com'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :email

  has_many :parsers, dependent: :destroy
  has_many :documents, through: :parsers
end
