module Mappers
  module Helpers
    module Base
      include GlobalSanitizers
      include GlobalLookups::DeductionTypeLookup
      include GlobalLookups::ParserLookup
      include GlobalLookups::PlanningRetailerLookup
      include GlobalLookups::RetailChainNameLookup
      # include LocalLookups::GiantEagleReclamationCharges
      # include LocalLookups::KeheWeeklyMcb
      # include LocalLookups::NcgDeductionForm
      # include LocalLookups::UnfiEastDeductionInvoice
      # include LocalLookups::UnfiEastQualityDeduction
      # include LocalLookups::UnfiEastWeeklyMcb
      # include LocalLookups::UnfiEastWestOverpullSupplierBillingReport
      # include LocalLookups::UnfiEastWestVendorBillbackForm
      # include LocalLookups::UnfiEastWholeFoods
      # include LocalLookups::UnfiWestProductLossClaimsReport
      # include LocalLookups::UnfiWestWeeklyMcb
    end
  end
end
