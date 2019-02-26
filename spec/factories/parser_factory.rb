FactoryBot.define do
  factory :parser do
    user
    external_id { SecureRandom.hex(8) }
    name  { 'Cat Scans' }
    destination_id { SecureRandom.hex(16) }
  end
end
