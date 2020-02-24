class SpreadsheetService
  attr_accessor :session, :user

  def initialize(user = nil)
    @session = DriveService.client
    @user = user ||= User.find_by(email: User::ADMIN_EMAIL)
  end

  def import_data!
    Parser.active.each do |parser|
      documents = DocumentService.get_documents(parser)

      documents.each do |document|
        doc = DocumentService.create_locally(parser, document)
        next if doc.processed?

        data = parse_and_prepare(document, parser) # parses and prepares rows
        next unless data

        doc.process! if DriveService.add_rows(session, parser, data) # returns true/false
      end
    end
  end

  def parse_and_prepare(document, parser)
    raw_rows = parser.parser_library.parse_rows(document)
    parser.mapper_library.prepare_rows(raw_rows)
  rescue StandardError => e
    ParseExceptionService.log!(e, document, parser)
    nil
  end
end
