admin_params = { email: User::ADMIN_EMAIL }
admin = User.find_by(admin_params)
User.create!(admin_params.merge('password' => 'password', 'password_confirmation' => 'password')) if admin.nil?

# prepare: Parser.all.map {|p| p.attributes.except('created_at', 'id', 'updated_at', 'user_id')}
parsers = [
  {"external_id"=>"1Z5by0rrvu1tVw5K2nXZRAJL3ct2TM7GS", "name"=>"UNFI East Weekly MCB", "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"source"=>"google_drive", "library"=>"UNFIEastWeeklyMCB"}},
  {"external_id"=>"xvexmuksclhe", "name"=>nil, "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"UNFIWestWeeklyMCB"}},
  {"external_id"=>"eylfucfqzted", "name"=>nil, "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"UNFIEastChargeback"}},
  {"external_id"=>"enowqxdfgcqg", "name"=>nil, "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"UNFIEastDeductionQuarterly"}},
  {"external_id"=>"azwkpkgfxroi", "name"=>"UNFI East Reclamation", "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"UNFIEastReclamation"}},
  {"external_id"=>"unkxjvdpcdwg", "name"=>"", "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"KeheWeeklyMCB"}},
  {"external_id"=>"hkoarkqejsvb", "name"=>nil, "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"KeheLateDeliveryFee"}},
  {"external_id"=>"bqwnqipeffxj", "name"=>nil, "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"KehePassThroughPromotion"}},
  {"external_id"=>"yajcqtqeuwhd", "name"=>nil, "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"KehePromotion"}},
  {"external_id"=>"hjczbplazgti", "name"=>nil, "destination_id"=>"1pWmdUxPRO7Id3HkhlsDJfTViGLKzdfIVKZ_Ad0memkE", "settings"=>{"library"=>"KeheSlotting"}},
  {"external_id"=>"yvxntiktsqho", "name"=>nil, "destination_id"=>"1sEjNPub3yXyEMdHCzLMLaUmOxNBNLiv5-o_GVNgutlo", "settings"=>{"library"=>"KeheAdInvoice"}},
  {"external_id"=>"lwaiygkncvdo", "name"=>nil, "destination_id"=>"1sEjNPub3yXyEMdHCzLMLaUmOxNBNLiv5-o_GVNgutlo", "settings"=>{"library"=>"KeheChargebackInvoiceHomestoreBilling"}},
  {"external_id"=>"gqcqsvamopbj", "name"=>nil, "destination_id"=>"1sEjNPub3yXyEMdHCzLMLaUmOxNBNLiv5-o_GVNgutlo", "settings"=>{"library"=>"KeheCouponInvoice"}},
  {"external_id"=>"pawpvontahrx", "name"=>nil, "destination_id"=>"1sEjNPub3yXyEMdHCzLMLaUmOxNBNLiv5-o_GVNgutlo", "settings"=>{"library"=>"KeheCustomerSpoilageAllowanceBillback"}}
]

# CHANGE DESTINATION IDS before production!!

parsers.each do |parser_attributes|
  admin.parsers.find_or_create_by(parser_attributes)
end
