class ParseMapException < ActiveRecord::Base
  belongs_to :parser
  validates_presence_of :parser_id

  after_create :alert_admin

  def alert_admin
    body = "file failed to map or parse: #{self.file_name}\n\nerror: #{self.error_message}"
    subject = "Document parse failure for Parser #{self.parser_id}"
    AdminMailer.custom(body, subject).deliver_now
  end
end
