# module UnfiEastWestVendorBillbackForm
#   class Base
#
#     LOOKUP_TABLE = [{"Invoice # Format"=>/GERCLM(\d{2}\d{2}\w+TXAU/,
#       "Invoice # Condition"=>/^GERCLM/,
#       "Customer"=>nil,
#       "Parser"=>"Giant Eagle Reclamation Charges",
#       "File Name"=>nil,
#       "Invoice Number"=>nil,
#       "Deduction Post Date"=>nil,
#       "Promo Start Date"=>"(mm)/01/(yyyy)",
#       "Promo End Date"=>"last day of applicable month",
#       "Deduction Type"=>"Spoilage",
#       "Deduction Description"=>"Giant Eagle Reclamation Charges",
#       "Customer Chain ID"=>"Giant Eagle",
#       "Customer Detailed Name"=>"Giant Eagle",
#       "Chargeback Amount"=>nil,
#       "Shipped"=>nil,
#       "Variable Rate per Unit"=>nil
#     }]
#
#     def lookup_condition(invoice_number)
#       LOOKUP_TABLE.each_with_index do |lookup, idx|
#         format = lookup['Invoice # Format']
#         condition = lookup['Invoice # Condition']
#         date_string = invoice_number.try(:scan,format).try(:flatten).try(:first)
#         if date_string && invoice_number.match?(condition)
#           return idx, date_string
#         end
#       end
#
#     end
#
#     def promo_dates
#       promo_dates = date_string_to_promo_dates(date_string)
#     end
#
#     def lookup_output(invoice_number)
#       table_id, date_string = lookup_condition(invoice_number)
#       dates = date_string_to_promo_dates(date_string)
#
#       lookup = LOOKUP_TABLE[table_id]
#
#       {
#         "Customer"=>lookup['Customer'],
#         "Parser"=>lookup['Parser'],
#         "Promo Start Date"=>dates['start_date'],
#         "Promo End Date"=>dates['end_date'],
#         "Deduction Type"=>lookup['Deduction Type'],
#         "Deduction Description"=>lookup['Deduction Description'],
#         "Customer Chain ID"=>lookup['Customer Chain ID'],
#         "Customer Detailed Name"=>lookup['Customer Detailed Name'],
#         "Chargeback Amount"=>lookup['Chargeback Amount'],
#         "Shipped"=>lookup['Shipped'],
#         "Variable Rate per Unit"=>lookup['Variable Rate per Unit']
#       }
#     end
#   end
# end
