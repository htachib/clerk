class Document < ActiveRecord::Base
  belongs_to :parser

  def process!
    update(processed: true)
  end
end
