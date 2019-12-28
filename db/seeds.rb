admin_params = { email: User::ADMIN_EMAIL }
admin = User.find_by(admin_params)
User.create!(admin_params.merge('password' => 'password', 'password_confirmation' => 'password')) if admin.nil?

production_spreadsheet = '1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE' # changed to new month
# prepare: Parser.all.map {|p| p.attributes.except('created_at', 'id', 'updated_at', 'user_id')}
parsers = [
  {"external_id"=>"1Z5by0rrvu1tVw5K2nXZRAJL3ct2TM7GS", "name"=>"UNFI East Weekly MCB", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"source"=>"google_drive", "library"=>"UnfiEastWeeklyMcb"}},
  {"external_id"=>"xvexmuksclhe", "name"=>"UNFI West Weekly MCB", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestWeeklyMcb"}},
  {"external_id"=>"eylfucfqzted", "name"=>"UNFI East Chargeback", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiEastChargeback"}},
  {"external_id"=>"enowqxdfgcqg", "name"=>"UNFI East Deduction Quarterly", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiEastDeductionQuarterly"}},
  {"external_id"=>"azwkpkgfxroi", "name"=>"UNFI East Reclamation", "destination_id"=>production_spreadsheet, "is_active"=>false, "settings"=>{"library"=>"UnfiEastReclamation"}},
  {"external_id"=>"unkxjvdpcdwg", "name"=>"KeHE Weekly MCB", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheWeeklyMcb"}},
  {"external_id"=>"hkoarkqejsvb", "name"=>"KeHE Late Delivery Fee", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheLateDeliveryFee"}},
  {"external_id"=>"bqwnqipeffxj", "name"=>"KeHE Pass Through Promotion", "destination_id"=>production_spreadsheet, "is_active"=>false, "settings"=>{"library"=>"KehePassThroughPromotion"}},
  {"external_id"=>"yajcqtqeuwhd", "name"=>"KeHE Promotion", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KehePromotion"}},
  {"external_id"=>"hjczbplazgti", "name"=>"KeHE Slotting", "destination_id"=>production_spreadsheet, "is_active"=>false, "settings"=>{"library"=>"KeheSlotting"}},
  {"external_id"=>"goxipbcwmkda", "name"=>"KeHE Ad Invoice", "destination_id"=>production_spreadsheet, "is_active"=>false, "settings"=>{"library"=>"KeheAdInvoice"}},
  {"external_id"=>"lwaiygkncvdo", "name"=>"KeHE Homestore Billing Chargeback / Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheHomestoreBillingChargebackInvoice"}},
  {"external_id"=>"gqcqsvamopbj", "name"=>"KeHE HEB Coupons", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheHebCouponsInactive"}},
  {"external_id"=>"pawpvontahrx", "name"=>"KeHE Customer Spoilage Allowance Billback", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheCustomerSpoilageAllowanceBillback"}},
  {"external_id"=>"lmncjdwbrpqy", "name"=>"KeHE Free Fill", "destination_id"=>production_spreadsheet, "is_active"=>false, "settings"=>{"library"=>"KeheFreeFill"}},
  {"external_id"=>"bepcjhlzdfsw", "name"=>"KeHE Invoice Adjustment", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheInvoiceAdjustment"}},
  {"external_id"=>"xzhgcymbtodl", "name"=>"KeHE Lumper Fee, Warehouse Support, FOB Surcharge", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheLumperFeeWarehouseSupportFobSurcharge"}},
  {"external_id"=>"uuopbrjehxkh", "name"=>"KeHE Merchandising Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheMerchandisingInvoice"}},
  {"external_id"=>"fcpastlnejqk", "name"=>"KeHE New Item Setup", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheNewItemSetup"}},
  {"external_id"=>"sjyigeaaixuy", "name"=>"KeHE Non-Service In Store Credits", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheNonserviceInStoreCredits"}},
  {"external_id"=>"jmqonywollnj", "name"=>"KeHE Reclamation Recovery", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheReclamationRecovery"}},
  {"external_id"=>"xaewjhkmblpm", "name"=>"KeHE Retailer Store Placement", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheRetailerStorePlacement"}},
  {"external_id"=>"ccyfadqnatez", "name"=>"KeHE Scan Invoice", "destination_id"=>production_spreadsheet, "is_active"=>false, "settings"=>{"library"=>"KeheScanInvoice"}},
  {"external_id"=>"agleizvdevis", "name"=>"KeHE HEB Shelf Activity Chargeback Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheHebShelfActivityChargebackInvoice"}},
  {"external_id"=>"wmgpevzcxqis", "name"=>"KeHE Albertsons Merchandising Program Chargeback Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheAlbertsonsMerchandisingProgramChargebackInvoice"}},
  {"external_id"=>"ulwnmxnybati", "name"=>"KeHE Roundy's Merchandising Charges", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheRoundysMerchandisingCharges"}},
  {"external_id"=>"whbatzonpcsk", "name"=>"KeHE Fresh Thyme Ad Fee", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheFreshThymeAdFee"}},
  {"external_id"=>"fxwngurhkizx", "name"=>"KeHE Fresh Thyme SAS Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheFreshThymeSasInvoice"}},
  {"external_id"=>"gdpsylxkjmnl", "name"=>"KeHE HEB Coupons", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheHebCoupons"}}
]
# CHANGE DESTINATION IDS before production!!

parsers.each do |parser_attributes|
  admin.parsers.find_or_create_by(parser_attributes)
end
