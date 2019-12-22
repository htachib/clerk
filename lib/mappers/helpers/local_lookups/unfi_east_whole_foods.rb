module UnfiEastWholeFoods
  class Base
    include GlobalSanitizers

    LOOKUP_TABLE = [
      {"Invoice # Format"=>/WFM(\d{3}\d{2})\w+ISEGRB"/,
      "Invoice # Condition"=>/^WFM\w+ISEGR\#$/,
      "Customer"=>nil,
      "Parser"=>"Whole Foods In Store Execution Fee",
      "File Name"=>nil,
      "Invoice Number"=>nil,
      "Deduction Post Date"=>nil,
      "Promo Start Date"=>"(mm)/01/(yyyy)",
      "Promo End Date"=>"last day of applicable month",
      "Deduction Type"=>"Off Invoice Allowance",
      "Deduction Description"=>"Whole Foods - In Store Execution Fee",
      "Customer Chain ID"=>"Whole Foods",
      "Customer Detailed Name"=>"Whole Foods",
      "Chargeback Amount"=>nil,
      "Shipped"=>nil,
      "Variable Rate per Unit"=>nil},
     {"Invoice # Format"=>/WHFDCPN\w+/,
      "Invoice # Condition"=>/^WHFDCPN/,
      "Customer"=>nil,
      "Parser"=>"Whole Foods Coupons, Scans",
      "File Name"=>nil,
      "Invoice Number"=>nil,
      "Deduction Post Date"=>nil,
      "Promo Start Date"=>nil,
      "Promo End Date"=>nil,
      "Deduction Type"=>"MCB",
      "Deduction Description"=>nil,
      "Customer Chain ID"=>"Whole Foods",
      "Customer Detailed Name"=>"Whole Foods",
      "Chargeback Amount"=>nil,
      "Shipped"=>nil,
      "Variable Rate per Unit"=>nil},
     {"Invoice # Format"=>/WHFDADS\w+/,
      "Invoice # Condition"=>/^WHFDADS/,
      "Customer"=>nil,
      "Parser"=>"Whole Foods Ad Fee",
      "File Name"=>nil,
      "Invoice Number"=>nil,
      "Deduction Post Date"=>nil,
      "Promo Start Date"=>nil,
      "Promo End Date"=>nil,
      "Deduction Type"=>"Ad Fee",
      "Deduction Description"=>nil,
      "Customer Chain ID"=>"Whole Foods",
      "Customer Detailed Name"=>"Whole Foods",
      "Chargeback Amount"=>nil,
      "Shipped"=>nil,
      "Variable Rate per Unit"=>nil},
     {"Invoice # Format"=>/WHFDSCAN\w+/,
      "Invoice # Condition"=>/^WHFDSCAN/,
      "Customer"=>nil,
      "Parser"=>"Whole Foods Coupons, Scans",
      "File Name"=>nil,
      "Invoice Number"=>nil,
      "Deduction Post Date"=>nil,
      "Promo Start Date"=>nil,
      "Promo End Date"=>nil,
      "Deduction Type"=>"Scan",
      "Deduction Description"=>nil,
      "Customer Chain ID"=>"Whole Foods",
      "Customer Detailed Name"=>"Whole Foods",
      "Chargeback Amount"=>nil,
      "Shipped"=>nil,
      "Variable Rate per Unit"=>nil}
    ]

    def lookup_condition(invoice_number)
      LOOKUP_TABLE.each_with_index do |lookup, idx|
        format = lookup['Invoice # Format']
        condition = lookup['Invoice # Condition']
        date_string = invoice_number.try(:scan,format).try(:flatten).try(:first)
        if date_string && invoice_number.match?(condition)
          return idx, date_string
        end
      end

    end

    def promo_dates
      promo_dates = date_string_to_promo_dates(date_string)
    end

    def lookup_output(invoice_number)
      table_id, date_string = lookup_condition(invoice_number)
      dates = date_string_to_promo_dates(date_string)

      lookup = LOOKUP_TABLE[table_id]

      {
        "Customer"=>lookup['Customer'],
        "Parser"=>lookup['Parser'],
        "Promo Start Date"=>dates['start_date'],
        "Promo End Date"=>dates['end_date'],
        "Deduction Type"=>lookup['Deduction Type'],
        "Deduction Description"=>lookup['Deduction Description'],
        "Customer Chain ID"=>lookup['Customer Chain ID'],
        "Customer Detailed Name"=>lookup['Customer Detailed Name'],
        "Chargeback Amount"=>lookup['Chargeback Amount'],
        "Shipped"=>lookup['Shipped'],
        "Variable Rate per Unit"=>lookup['Variable Rate per Unit']
      }
    end
  end
end
