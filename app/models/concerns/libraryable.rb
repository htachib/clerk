module Libraryable
  extend ActiveSupport::Concern

  def library_name
    settings.dig('library')
  end

  def parser_library
    "Parsers::#{library_name}".constantize
  end

  def mapper_library
    "Mappers::#{library_name}".constantize
  end
end
