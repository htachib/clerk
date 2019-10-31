module DashboardHelper
  def last_processed(parser)
    if parser.last_processed_document
      "#{time_ago_in_words(parser.last_processed_document.created_at)} ago"
    else
      'n/a'
    end
  end
end
