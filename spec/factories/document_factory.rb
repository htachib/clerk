FactoryBot.define do
  factory :document do
    parser
    external_id { SecureRandom.hex(16) }
    name  { 'Cat-Scan-2019.pdf' }
  end
end
