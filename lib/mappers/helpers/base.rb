module Mappers
  module Helpers
    module Base
      include GlobalSanitizers
      include GlobalLookups::DeductionTypeLookup
      include GlobalLookups::ParserLookup
      include GlobalLookups::PlanningRetailerLookup
      include GlobalLookups::RetailChainNameLookup
    end
  end
end
