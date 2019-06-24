FactoryBot.define do
  factory :parse_map_exception do
    error_message { "undefined method `split' for nil:NilClass" }
    file_name  { 'Unfi-invoice-23423.pdf' }
    content { { some: 'content', 'string-key' => 15 } }

    parser
  end
end
