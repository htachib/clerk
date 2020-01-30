admin_params = { email: User::ADMIN_EMAIL }
admin = User.find_by(admin_params)
User.create!(admin_params.merge('password' => 'password', 'password_confirmation' => 'password')) if admin.nil?

production_spreadsheet = '1HqExgCGtmkiB1XX3BRI67w-k8NHZSReE06Sih7P68mM' # changed to new month
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
  {"external_id"=>"agleizvdevis", "name"=>"KeHE HEB Shelf Activity Chargeback Invoice", "destination_id"=>production_spreadsheet, "is_active"=>false, "settings"=>{"library"=>"KeheHebShelfActivityChargebackInvoice"}},
  {"external_id"=>"wmgpevzcxqis", "name"=>"KeHE Albertsons Merchandising Program Chargeback Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheAlbertsonsMerchandisingProgramChargebackInvoice"}},
  {"external_id"=>"ulwnmxnybati", "name"=>"KeHE Roundy's Merchandising Charges", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheRoundysMerchandisingCharges"}},
  {"external_id"=>"whbatzonpcsk", "name"=>"KeHE Fresh Thyme Ad Fee", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheFreshThymeAdFee"}},
  {"external_id"=>"fxwngurhkizx", "name"=>"KeHE Fresh Thyme SAS Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheFreshThymeSasInvoice"}},
  {"external_id"=>"gdpsylxkjmnl", "name"=>"KeHE HEB Coupons", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheHebCoupons"}},
  {"external_id"=>"oulxzaysftaw", "name"=>"KeHE Albertsons-Safeway Required Free Goods", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheAlbertsonsSafewayRequiredFreeGoods"}},
  {"external_id"=>"gbhblojzckps", "name"=>"KeHE Customer Spoilage Allowance Billback", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheCustomerSpoilageAllowanceBillback"}},
  {"external_id"=>"pyiphgvkbjio", "name"=>"KeHE HEB Reclamation Recovery", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheHebReclamationRecovery"}},
  {"external_id"=>"zafkysciprhj", "name"=>"KeHE HEB Shelf Activity Chargeback Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheHebShelfActivityChargebackInvoice"}},
  {"external_id"=>"ymjzlsadbvox", "name"=>"KeHE Homestore Billing Chargeback / Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheHomestoreBillingChargebackInvoice"}},
  {"external_id"=>"myhjpudjigxm", "name"=>"KeHE Lumper Fee, Warehouse Support, FOB Surcharge", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheLumperFeeWarehouseSupportFobSurcharge"}},
  {"external_id"=>"krsizcxvlgen", "name"=>"KeHE Meijer Scans Chargeback Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheMeijerScansChargebackInvoice"}},
  {"external_id"=>"ehkfzldmgixz", "name"=>"KeHE Placement Chargeback Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KehePlacementChargebackInvoice"}},
  {"external_id"=>"jqenbzldutwy", "name"=>"KeHE Reclamation Recovery", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheReclamationRecovery"}},
  {"external_id"=>"yjobtruvfgym", "name"=>"KeHE Retailer Store Placement", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheRetailerStorePlacement"}},
  {"external_id"=>"yvbqzgolvhjg", "name"=>"KeHE Roundy's Scan Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheRoundysScanInvoice"}},
  {"external_id"=>"gmzvcabkxufw", "name"=>"KeHE Safeway Promo Pass Through", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSafewayPromoPassThrough"}},
  {"external_id"=>"kfmbismjczyg", "name"=>"KeHE Safeway Scan Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSafewayScanInvoice"}},
  {"external_id"=>"dymllehzmifp", "name"=>"KeHE Safeway Slotting Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSafewaySlottingInvoice"}},
  {"external_id"=>"cdhelmxwutgi", "name"=>"KeHE Spoilage", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSpoilage"}},
  {"external_id"=>"vfeaxqoegphy", "name"=>"KeHE Sprouts Advertisement", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSproutsAdvertisement"}},
  {"external_id"=>"asqxpidrhowu", "name"=>"KeHE Sprouts Placement", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSproutsPlacement"}},
  {"external_id"=>"wfkubxvyarpt", "name"=>"KeHE Sprouts Promotion (Merchandising)", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSproutsPromotionMerchandising"}},
  {"external_id"=>"atbhnxjhmwfq", "name"=>"KeHE Sprouts Scans", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSproutsScans"}},
  {"external_id"=>"oxnriuwlfynj", "name"=>"KeHE United Scan Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheUnitedScanInvoice"}},
  {"external_id"=>"atrhhxkrzmed", "name"=>"KeHE Vendor Chargeback Report", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheVendorChargebackReport"}},
  {"external_id"=>"entzmqsvwhlo", "name"=>"KeHE Slotting / Placement", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheSlottingPlacement"}},
  {"external_id"=>"sgxpwdeldmaf", "name"=>"KeHE Invoice Adjustment", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KeheInvoiceAdjustment"}},
  {"external_id"=>"xvdfkaqiekms", "name"=>"UNFI West Gelson's Markets Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestGelsonsMarketsDeductionForm"}},
  {"external_id"=>"egemrhusqnpq", "name"=>"UNFI West Lazy Acres Market Inc Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestLazyAcresMarketIncDeductionForm"}},
  {"external_id"=>"pcwjyahbmeiw", "name"=>"UNFI West Bristol Farms Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestBristolFarmsDeductionForm"}},
  {"external_id"=>"fkbdqhfziyvw", "name"=>"UNFI West Akins Natural Foods Supermarket Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestAkinsNaturalFoodsSupermarketDeductionForm"}},
  {"external_id"=>"twylugwclujn", "name"=>"UNFI West Bashas Inc Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestBashasIncDeductionForm"}},
  {"external_id"=>"dxelskbnmvli", "name"=>"UNFI West Mollie Stone's Market Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestMollieStonesMarketDeductionForm"}},
  {"external_id"=>"fqxdkqidfyet", "name"=>"UNFI West Raleys Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestRaleysDeductionForm"}},
  {"external_id"=>"ejvuhpkkfxyz", "name"=>"UNFI West Yoke's Fresh Market Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestYokesFreshMarketDeductionForm"}},
  {"external_id"=>"uowsqqfvhxcd", "name"=>"UNFI West Whole Foods In Store Execution Fee", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestWholeFoodsInStoreExecutionFee"}},
  {"external_id"=>"ujgtsdufyfpq", "name"=>"UNFI West NCG Deduction Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestNcgDeductionForm"}},
  {"external_id"=>"fvzthnbqssbv", "name"=>"UNFI West Chargeback", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestChargeback"}},
  {"external_id"=>"vqzvmcimjhir", "name"=>"UNFI West Deduction Invoice", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestDeductionInvoice"}},
  {"external_id"=>"embozyybspxw", "name"=>"UNFI West Overpull Supplier Billing Report", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestOverpullSupplierBillingReport"}},
  {"external_id"=>"pvggbzefsohh", "name"=>"UNFI West Product Loss Claims Report", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestProductLossClaimsReport"}},
  {"external_id"=>"edfhqquomghn", "name"=>"UNFI West Vendor Billback Form", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiWestVendorBillbackForm"}},
  {"external_id"=>"paonxvnoikme", "name"=>"Kroger Coupon", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KrogerCoupon"}},
  {"external_id"=>"znoxesmkbaeo", "name"=>"Kroger KOMPASS Merchandising", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KrogerKompassMerchandising"}},
  {"external_id"=>"fdowpcikvbkt", "name"=>"Kroger Freight - Unloading Fees", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KrogerFreightUnloadingFees"}},
  {"external_id"=>"xroudvlnczed", "name"=>"Kroger KATS", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"KrogerKats"}},
  {"external_id"=>"abfutsnywgwo", "name"=>"DPI Customer Reset Deductions - Kroger", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"DpiCustomerResetDeductionsKroger"}},
  {"external_id"=>"dkupzwlmncau", "name"=>"DPI MCB", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"DpiMcb"}},
  {"external_id"=>"1KXsS6ewb6U9C_gOIKEmS9EK6JzxA4IU1", "name"=>"DPI Spoilage", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"source"=>"google_drive", "library"=>"DpiSpoilage"}},
  {"external_id"=>"14irlI9TfYc6aiwQ4thaUniUVALGLiiA-", "name"=>"UNFI East Reclaim Vendor Chargeback Report", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"source"=>"google_drive", "subfolder"=>"10TbNWtB-D5qjPIzGOlo4BFfCUKzq7xOx", "library"=>"UnfiEastReclaimVendorChargebackReport"}},
  {"external_id"=>"zdeazcgwlmay", "name"=>"UNFI East Reclaim Vendor Chargeback Report", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiEastReclaimVendorChargebackReport"}},
  {"external_id"=>"giaozenycspr", "name"=>"UNFI East Quality Deduction", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiEastQualityDeduction"}},
  {"external_id"=>"wbiugfbmfpdy", "name"=>"UNFI East Giant Eagle Reclamation Charges", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiEastGiantEagleReclamationCharges"}},
  {"external_id"=>"hflqrmhfzbej", "name"=>"UNFI East Whole Foods In Store Execution Fee", "destination_id"=>production_spreadsheet, "is_active"=>true, "settings"=>{"library"=>"UnfiEastWholeFoodsInStoreExecutionFee"}}


]
# CHANGE DESTINATION IDS before production!!
# temporary dev: 1Ay0FNPTrSjTTU8zBVhHYuQ0n_XOTgZDhBsWNuYJ9M7w
# Instructions for Prod:
# 1. Add parsers to heroku run rails c
# 2. Add input folders and add integration with Google Drive to Docparser

parsers.each do |parser_attributes|
  admin.parsers.find_or_create_by(parser_attributes)
end
