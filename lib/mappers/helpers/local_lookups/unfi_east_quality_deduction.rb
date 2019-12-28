module UnfiEastQualityDeduction
  class Base

    def lookup_condition(invoice_number)
      /CMQ\d{4}\w+/ === invoice_number
    end

    def lookup_output(invoice_number)
      if lookup_condition(invoice_number)
        date_int = invoice_number.try(:scan,/CMQ(\d{4})\w+/).try(:flatten).try(:first)
        dates = date_string_to_promo_dates(date_int)

        {
          "Promo Start Date"=>dates['start_date'],
          "Promo End Date"=>dates['end_date'],
          "Deduction Type"=>"Spoilage",
          "Deduction Description"=>"UNFI East Quality Manufacturer Chargeback",
          "Customer Chain ID"=>"UNFI East",
          "Customer Detailed Name"=>"UNFI East",
        }
      end
    end
  end
end
