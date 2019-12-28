module Mappers
  module Helpers
    module GlobalLookups
      module ParserLookup
        PARSER_TO_DEDUCTION_CUSTOMER_LOOKUP = [
          {"Parser"=>"Kroger KATS", "Deduction Type"=>"MCB", "Deduction Description"=>nil, "Customer Chain ID"=>"Kroger", "Customer Detailed Name"=>"Kroger"},
          {"Parser"=>"Kroger Coupon", "Deduction Type"=>"MCB", "Deduction Description"=>nil, "Customer Chain ID"=>"Kroger", "Customer Detailed Name"=>"Kroger"},
          {"Parser"=>"Kroger KOMPASS Merchandising", "Deduction Type"=>"Merchandising", "Deduction Description"=>nil, "Customer Chain ID"=>"Kroger", "Customer Detailed Name"=>"Kroger"},
          {"Parser"=>"Kroger Freight - Unloading Fees", "Deduction Type"=>"Freight", "Deduction Description"=>nil, "Customer Chain ID"=>"Kroger", "Customer Detailed Name"=>"Kroger"},
          {"Parser"=>"DPI Customer Reset Deductions - Kroger", "Deduction Type"=>"Merchandising", "Deduction Description"=>"KOMPASS Merchandising Services", "Customer Chain ID"=>"Kroger", "Customer Detailed Name"=>"Kroger"},
          {"Parser"=>"DPI MCB", "Deduction Type"=>"MCB", "Deduction Description"=>nil, "Customer Chain ID"=>nil, "Customer Detailed Name"=>nil},
          {"Parser"=>"DPI Spoilage", "Deduction Type"=>"Spoilage", "Deduction Description"=>nil, "Customer Chain ID"=>nil, "Customer Detailed Name"=>nil},
          {"Parser"=>"KeHE Albertsons Merchandising Program Chargeback Invoice", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Albertsons Merchandising Program", "Customer Chain ID"=>"Safeway / Albertsons", "Customer Detailed Name"=>"Albertsons"},
          {"Parser"=>"KeHE Albertsons-Safeway Required Free Goods", "Deduction Type"=>"Free Fill", "Deduction Description"=>nil, "Customer Chain ID"=>"Safeway / Albertsons", "Customer Detailed Name"=>"Safeway / Albertsons"},
          {"Parser"=>"KeHE Customer Spoilage Allowance Billback", "Deduction Type"=>"Spoilage", "Deduction Description"=>nil, "Customer Chain ID"=>"KeHE", "Customer Detailed Name"=>"KeHE"},
          {"Parser"=>"KeHE Fresh Thyme Ad Fee", "Deduction Type"=>"Ad Fee", "Deduction Description"=>nil, "Customer Chain ID"=>"Fresh Thyme", "Customer Detailed Name"=>"Fresh Thyme"},
          {"Parser"=>"KeHE Fresh Thyme SAS Invoice", "Deduction Type"=>"Merchandising", "Deduction Description"=>nil, "Customer Chain ID"=>"Fresh Thyme", "Customer Detailed Name"=>"Fresh Thyme"},
          {"Parser"=>"KeHE HEB Coupons", "Deduction Type"=>"Scan", "Deduction Description"=>"HEB Coupons", "Customer Chain ID"=>"HEB", "Customer Detailed Name"=>"HEB"},
          {"Parser"=>"KeHE HEB Reclamation Recovery", "Deduction Type"=>"Spoilage", "Deduction Description"=>nil, "Customer Chain ID"=>"HEB", "Customer Detailed Name"=>"HEB"},
          {"Parser"=>"KeHE HEB Shelf Activity Chargeback Invoice", "Deduction Type"=>"Merchandising", "Deduction Description"=>nil, "Customer Chain ID"=>"HEB", "Customer Detailed Name"=>"HEB"},
          {"Parser"=>"KeHE Homestore Billing Chargeback / Invoice", "Deduction Type"=>"MCB", "Deduction Description"=>"MCB Chargeback / Invoice", "Customer Chain ID"=>"Meijer", "Customer Detailed Name"=>"Meijer"},
          {"Parser"=>"KeHE Late Delivery Fee", "Deduction Type"=>"Freight", "Deduction Description"=>"Delivered Late Fee", "Customer Chain ID"=>"KeHE", "Customer Detailed Name"=>"KeHE"},
          {"Parser"=>"KeHE Lumper Fee, Warehouse Support, FOB Surcharge", "Deduction Type"=>"Freight", "Deduction Description"=>nil, "Customer Chain ID"=>"KeHE", "Customer Detailed Name"=>"KeHE"},
          {"Parser"=>"KeHE Meijer Scans Chargeback Invoice", "Deduction Type"=>"Scan", "Deduction Description"=>nil, "Customer Chain ID"=>"Meijer", "Customer Detailed Name"=>"Meijer"},
          {"Parser"=>"KeHE Placement Chargeback Invoice", "Deduction Type"=>"Free Fill", "Deduction Description"=>"Free Fill Chargeback / Invoice", "Customer Chain ID"=>nil, "Customer Detailed Name"=>nil},
          {"Parser"=>"KeHE Reclamation Recovery", "Deduction Type"=>"Spoilage", "Deduction Description"=>nil, "Customer Chain ID"=>nil, "Customer Detailed Name"=>nil},
          {"Parser"=>"KeHE Retailer Store Placement", "Deduction Type"=>"Free Fill", "Deduction Description"=>nil, "Customer Chain ID"=>nil, "Customer Detailed Name"=>nil},
          {"Parser"=>"KeHE Roundy's Merchandising Charges", "Deduction Type"=>"Merchandising", "Deduction Description"=>nil, "Customer Chain ID"=>"Roundy's", "Customer Detailed Name"=>"Roundy's"},
          {"Parser"=>"KeHE Roundy's Scan Invoice", "Deduction Type"=>"Scan", "Deduction Description"=>nil, "Customer Chain ID"=>"Roundy's", "Customer Detailed Name"=>"Roundy's"},
          {"Parser"=>"KeHE Safeway Promo Pass Through", "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Safeway / Albertsons", "Customer Detailed Name"=>"Safeway"},
          {"Parser"=>"KeHE Safeway Scan Invoice", "Deduction Type"=>"Scan", "Deduction Description"=>nil, "Customer Chain ID"=>"Safeway / Albertsons", "Customer Detailed Name"=>"Safeway"},
          {"Parser"=>"KeHE Safeway Slotting Invoice", "Deduction Type"=>"Slotting", "Deduction Description"=>nil, "Customer Chain ID"=>"Safeway / Albertsons", "Customer Detailed Name"=>"Safeway"},
          {"Parser"=>"KeHE Spoilage", "Deduction Type"=>"Spoilage", "Deduction Description"=>nil, "Customer Chain ID"=>"KeHE", "Customer Detailed Name"=>nil},
          {"Parser"=>"KeHE Sprouts Advertisement", "Deduction Type"=>"Ad Fee", "Deduction Description"=>"Sprouts Advertisement", "Customer Chain ID"=>"Sprouts", "Customer Detailed Name"=>"Sprouts"},
          {"Parser"=>"KeHE Sprouts Placement", "Deduction Type"=>"Free Fill", "Deduction Description"=>nil, "Customer Chain ID"=>"Sprouts", "Customer Detailed Name"=>"Sprouts"},
          {"Parser"=>"KeHE Sprouts Promotion (Merchandising)", "Deduction Type"=>"Merchandising", "Deduction Description"=>nil, "Customer Chain ID"=>"Sprouts", "Customer Detailed Name"=>"Sprouts"},
          {"Parser"=>"KeHE Sprouts Scans", "Deduction Type"=>"Scan", "Deduction Description"=>nil, "Customer Chain ID"=>"Sprouts", "Customer Detailed Name"=>"Sprouts"},
          {"Parser"=>"KeHE United Scan Invoice", "Deduction Type"=>"Scan", "Deduction Description"=>nil, "Customer Chain ID"=>"Safeway / Albertsons", "Customer Detailed Name"=>"United"},
          {"Parser"=>"KeHE Vendor Chargeback Report", "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"KeHE", "Customer Detailed Name"=>nil},
          {"Parser"=>"UNFI East Reclaim Vendor Chargeback Report", "Deduction Type"=>"Spoilage", "Deduction Description"=>"Reclaim Vendor Chargeback Report", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
          {"Parser"=>"UNFI West Chargeback", "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"UNFI West", "Customer Detailed Name"=>"UNFI West"},
          {"Parser"=>"Gelson's Markets Deduction Form", "Deduction Type"=>"Scan", "Deduction Description"=>"Gelson's Price Reduction + Display Fee", "Customer Chain ID"=>"Gelson's Markets", "Customer Detailed Name"=>"Gelson's Markets"},
          {"Parser"=>"Lazy Acres Market Inc Deduction Form", "Deduction Type"=>"Scan", "Deduction Description"=>"Lazy Acres - Scan + Co-Op Fee", "Customer Chain ID"=>"Lazy Acres", "Customer Detailed Name"=>"Lazy Acres"},
          {"Parser"=>"Bristol Farms Deduction Form", "Deduction Type"=>"MCB", "Deduction Description"=>"Bristol Farms - TPR + Ad Fees", "Customer Chain ID"=>"Bristol Farms", "Customer Detailed Name"=>"Bristol Farms"},
          {"Parser"=>"Akins Natural Foods Supermarket Deduction Form", "Deduction Type"=>"MCB", "Deduction Description"=>"Akins - TPR + Ad Fees", "Customer Chain ID"=>"Akins Natural Foods", "Customer Detailed Name"=>"Akins Natural Foods"},
          {"Parser"=>"Bashas Inc Deduction Form", "Deduction Type"=>"MCB", "Deduction Description"=>nil, "Customer Chain ID"=>"Bashas", "Customer Detailed Name"=>"Bashas"},
          {"Parser"=>"Mollie Stone's Market Deduction Form", "Deduction Type"=>"MCB", "Deduction Description"=>"Mollie Stone's - TPR + Ad Fees", "Customer Chain ID"=>"Mollie Stone's", "Customer Detailed Name"=>"Mollie Stone's"},
          {"Parser"=>"Raleys Deduction Form", "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Raleys", "Customer Detailed Name"=>"Raleys"},
          {"Parser"=>"Yoke's Fresh Market Deduction Form", "Deduction Type"=>"MCB", "Deduction Description"=>"Yoke's - MCB + Ad Fee", "Customer Chain ID"=>"Yoke's Fresh Market", "Customer Detailed Name"=>"Yoke's Fresh Market"}
        ]

        def get_parser_lookup(parser_name)
          PARSER_TO_DEDUCTION_CUSTOMER_LOOKUP.each do |lookup|
            return lookup if lookup['Parser'] == parser_name
          end
        end
      end
    end
  end
end
