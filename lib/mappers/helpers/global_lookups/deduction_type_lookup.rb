module Mappers
  module Helpers
    module GlobalLookups
      module DeductionTypeLookup
        DEDUCTION_TYPE_LOOKUP = [
          {"Deduction Type"=>"3 PTY", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Ad Fee", "Deduction Category"=>"Fixed Allowance - Ad Fee", "Deduction Account"=>"44102 - Fixed Sales Allowances"},
          {"Deduction Type"=>"ADS", "Deduction Category"=>"Fixed Allowance - Ad Fee", "Deduction Account"=>"44102 - Fixed Sales Allowances"},
          {"Deduction Type"=>"Coupon", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Demos", "Deduction Category"=>"Selling Expense - Demos", "Deduction Account"=>"60360 - Field Marketing"},
          {"Deduction Type"=>"Free Fill", "Deduction Category"=>"Slotting and Free Fill", "Deduction Account"=>"44300 - Free Fills & Slotting"},
          {"Deduction Type"=>"Freight", "Deduction Category"=>"Freight Expense", "Deduction Account"=>"53100 - Outbound Freight"},
          {"Deduction Type"=>"Markdowns", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"MCB", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Merchandising", "Deduction Category"=>"Selling Expense - Merchandising", "Deduction Account"=>"60370 - Merchandising"},
          {"Deduction Type"=>"Off Invoice Allowance", "Deduction Category"=>"Variable Allowance - Off Invoice", "Deduction Account"=>"44200 - Off Invoice Allowances"},
          {"Deduction Type"=>"Processing Fee", "Deduction Category"=>"Deduction Processing Fee", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Promo Fund", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Sales Report", "Deduction Category"=>"Selling Expense - Reports and Data", "Deduction Account"=>"60300 - Retail Marketing"},
          {"Deduction Type"=>"Samples", "Deduction Category"=>"Selling Expense - Samples", "Deduction Account"=>"60310 - Marketing & Sales Samples"},
          {"Deduction Type"=>"Scan", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Scan Rebate", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Scans", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Scans/Coupons", "Deduction Category"=>"Variable Allowance - MCB, Scan, Coupon", "Deduction Account"=>"44101 - MCB Chargeback"},
          {"Deduction Type"=>"Shortage", "Deduction Category"=>"Shortage", "Deduction Account"=>"41000 - Product Sales"},
          {"Deduction Type"=>"Slotting", "Deduction Category"=>"Slotting and Free Fill", "Deduction Account"=>"44300 - Free Fills & Slotting"},
          {"Deduction Type"=>"Spoilage", "Deduction Category"=>"Spoilage", "Deduction Account"=>"43200 - Spoils"},
          {"Deduction Type"=>"Trade Shows", "Deduction Category"=>"Selling Expense - Trade Shows", "Deduction Account"=>"60340 - Tradeshows"}
        ]

        def get_deduction_type_lookup(deduction_type)
          DEDUCTION_TYPE_LOOKUP.each do |lookup|
            return lookup if lookup['Deduction Type'] == deduction_type
          end

          {"Deduction Type"=>deduction_type, "Deduction Category"=>"N/A in Deduction Type Lookup", "Deduction Account"=>"N/A in Deduction Type Lookup"}
        end
      end
    end
  end
end
