class Document < ActiveRecord::Base
  belongs_to :parser

  def process!
    update(processed: true)
    # TODO: move file from G Drive to '{{ parser_name }} - BACKUP' folder
  end
end
