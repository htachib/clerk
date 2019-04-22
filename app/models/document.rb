class Document < ActiveRecord::Base
  belongs_to :parser

  scope :processed, -> { where(processed: true) }

  def process!
    update(processed: true)
    # TODO: move file from G Drive to '{{ parser_name }} - BACKUP' folder
  end
end
