class ParseExceptionService
  class << self
    def log!(exception, document, parser)
      ParseMapException.create!(
        parser: parser,
        file_name: DocumentService.file_name(document),
        content: document,
        error_message: exception.message
      )
    end
  end
end
