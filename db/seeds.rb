admin_params = { email: User::ADMIN_EMAIL }
admin = User.find_by(admin_params)
User.create!(admin_params.merge('password' => 'password', 'password_confirmation' => 'password')) if admin.nil?

production_spreadsheet = '1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE'
# prepare: Parser.all.map {|p| p.attributes.except('created_at', 'id', 'updated_at', 'user_id')}
parsers = [
  {"external_id"=>"1Z5by0rrvu1tVw5K2nXZRAJL3ct2TM7GS", "name"=>"UNFI East Weekly MCB", "destination_id" => production_spreadsheet, "settings"=>{"source"=>"google_drive", "library"=>"UNFIEastWeeklyMCB"}},
  {"external_id"=>"xvexmuksclhe", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"UNFIWestWeeklyMCB"}},
  {"external_id"=>"eylfucfqzted", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"UNFIEastChargeback"}},
  {"external_id"=>"enowqxdfgcqg", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"UNFIEastDeductionQuarterly"}},
  {"external_id"=>"azwkpkgfxroi", "name"=>"UNFI East Reclamation", "destination_id" => production_spreadsheet, "settings"=>{"library"=>"UNFIEastReclamation"}},
  {"external_id"=>"unkxjvdpcdwg", "name"=>"", "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheWeeklyMCB"}},
  {"external_id"=>"hkoarkqejsvb", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheLateDeliveryFee"}},
  {"external_id"=>"bqwnqipeffxj", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KehePassThroughPromotion"}},
  {"external_id"=>"yajcqtqeuwhd", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KehePromotion"}},
  {"external_id"=>"hjczbplazgti", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheSlotting"}},
  {"external_id"=>"goxipbcwmkda", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheAdInvoice"}},
  {"external_id"=>"lwaiygkncvdo", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheChargebackInvoiceHomestoreBilling"}},
  {"external_id"=>"gqcqsvamopbj", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheCouponInvoice"}},
  {"external_id"=>"pawpvontahrx", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheCustomerSpoilageAllowanceBillback"}},
  {"external_id"=>"lmncjdwbrpqy", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheFreeFill"}},
  {"external_id"=>"bepcjhlzdfsw", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheInvoiceAdjustment"}},
  {"external_id"=>"xzhgcymbtodl", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheLumperFeeChargebackInvoice"}},
  {"external_id"=>"uuopbrjehxkh", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheMerchandisingInvoice"}},
  {"external_id"=>"fcpastlnejqk", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheNewItemSetup"}},
  {"external_id"=>"sjyigeaaixuy", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheNonserviceInStoreCredits"}},
  {"external_id"=>"jmqonywollnj", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheReclamation"}},
  {"external_id"=>"xaewjhkmblpm", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheRetailerStorePlacement"}},
  {"external_id"=>"ccyfadqnatez", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheScanInvoice"}},
  {"external_id"=>"agleizvdevis", "name"=>nil, "destination_id" => production_spreadsheet, "settings"=>{"library"=>"KeheShelfActivityFee"}}
]
# CHANGE DESTINATION IDS before production!!

parsers.each do |parser_attributes|
  admin.parsers.find_or_create_by(parser_attributes)
end
