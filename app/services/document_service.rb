class DocumentService
  class << self
    def get_documents(session, parser)
      if parser.settings.dig('source') == 'google_drive'
        DriveService.fetch_documents_from_folder(session, parser)
      else
        DocParserService.fetch_documents(parser.external_id)
      end
    end

    def create_locally(parser, document)
      external_id = external_id(document)
      file_name = file_name(document)

      parser.documents.find_or_create_by(external_id: external_id, name: file_name)
    end

    def external_id(document)
      document.try(:id) || document.dig('id') # sheet, docparser
    end

    def file_name(document)
      document.try(:name) || document.dig('file_name')
    end
  end
end
