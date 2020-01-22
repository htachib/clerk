module Mappers
  module Helpers
    module GlobalLookups
      module InvoiceNumberLookup
        INVOICE_NUMBER_TO_DEDUCTION_CUSTOMER_LOOKUP = [
         {"Invoice # Format"=>/CMQ\w{3}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"CMQ\"", "Parser"=>"UNFI East Quality Deduction", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Spoilage", "Deduction Description"=>"UNFI East Quality Manufacturer Chargeback", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/GERCLM\d{2}\d{2}.*TXAU/, "Invoice # Condition"=>"BEGINS WITH \"GERCLM\"", "Parser"=>"Giant Eagle Reclamation Charges", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Spoilage", "Deduction Description"=>"Giant Eagle Reclamation Charges", "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/.*AHOLD/, "Invoice # Condition"=>"ENDS WITH \"AHOLD\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Ahold / Stop & Shop", "Customer Detailed Name"=>"Ahold / Stop & Shop"},
         {"Invoice # Format"=>/.*BIGY/, "Invoice # Condition"=>"ENDS WITH \"BIGY\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Big Y", "Customer Detailed Name"=>"Big Y"},
         {"Invoice # Format"=>/.*DIBRGS/, "Invoice # Condition"=>"ENDS WITH \"DIBRGS\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Dierberg's", "Customer Detailed Name"=>"Dierberg's"},
         {"Invoice # Format"=>/.*EOM/, "Invoice # Condition"=>"ENDS WITH \"EOM\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Earth Origins", "Customer Detailed Name"=>"Earth Origins"},
         {"Invoice # Format"=>/.*EFA/, "Invoice # Condition"=>"ENDS WITH \"EFA\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Earth Fare", "Customer Detailed Name"=>"Earth Fare"},
         {"Invoice # Format"=>/.*GEAGLE/, "Invoice # Condition"=>"ENDS WITH \"GEAGLE\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/FSRGE\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"FSRGE\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Giant Eagle", "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/FSRGE\w{3}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"FSRGE\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Giant Eagle", "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/.*GEAGLE/, "Invoice # Condition"=>"ENDS WITH \"GEAGLE\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/FSRGE\d{2}\d{2}.*A/, "Invoice # Condition"=>"BEGINS WITH \"FSRGE\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Giant Eagle", "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/FSRGE\w{3}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"FSRGE\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Giant Eagle", "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/.*GEAGLE/, "Invoice # Condition"=>"ENDS WITH \"GEAGLE\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/NSOKOW.*HCM/, "Invoice # Condition"=>"BEGINS WITH \"NSOKOW\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"Free Fill", "Deduction Description"=>"New Store Opening - Kowalski", "Customer Chain ID"=>"Kowalski", "Customer Detailed Name"=>"Kowalski"},
         {"Invoice # Format"=>/.*PUBLIX/, "Invoice # Condition"=>"ENDS WITH \"PUBLIX\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Publix", "Customer Detailed Name"=>"Publix"},
         {"Invoice # Format"=>/.*TFM/, "Invoice # Condition"=>"ENDS WITH \"TFM\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"The Fresh Market", "Customer Detailed Name"=>"Fresh Market"},
         {"Invoice # Format"=>/FSRTFM\d{2}\d{2}.*PB/, "Invoice # Condition"=>"BEGINS WITH \"FSRTFM\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - The Fresh Market", "Customer Chain ID"=>"The Fresh Market", "Customer Detailed Name"=>"The Fresh Market"},
         {"Invoice # Format"=>/FSRTFMGR\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"FSRTFMGR\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - The Fresh Market", "Customer Chain ID"=>"The Fresh Market", "Customer Detailed Name"=>"The Fresh Market"},
         {"Invoice # Format"=>/.*TFM/, "Invoice # Condition"=>"ENDS WITH \"TFM\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"The Fresh Market", "Customer Detailed Name"=>"Fresh Market"},
         {"Invoice # Format"=>/FSRTFMGR\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"FSRTFMGR\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - The Fresh Market", "Customer Chain ID"=>"The Fresh Market", "Customer Detailed Name"=>"The Fresh Market"},
         {"Invoice # Format"=>/FSRTFMGR\w{3}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"FSRTFMGR\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - The Fresh Market", "Customer Chain ID"=>"The Fresh Market", "Customer Detailed Name"=>"The Fresh Market"},
         {"Invoice # Format"=>/.*TFM/, "Invoice # Condition"=>"ENDS WITH \"TFM\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"The Fresh Market", "Customer Detailed Name"=>"Fresh Market"},
         {"Invoice # Format"=>/ERDC\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"ERDC\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Ad Fee", "Deduction Description"=>"Advertising - Quarterly Ad Billings", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/EROSF\d{4}.*/, "Invoice # Condition"=>"BEGINS WITH \"EROSF\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Shortage", "Deduction Description"=>"Over Shipment Fee", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/ERNACVTN\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"ERNACVTN\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Slotting", "Deduction Description"=>"New Item Activation Fee", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/FSRGE\w{3}\d{2}.*PB/, "Invoice # Condition"=>"BEGINS WITH \"FSRGE\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Giant Eagle", "Customer Chain ID"=>"Giant Eagle", "Customer Detailed Name"=>"Giant Eagle"},
         {"Invoice # Format"=>/ERVELCTY\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"ERVELCTY\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Sales Report", "Deduction Description"=>"Velocity Report", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/ERDC\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"ERDC\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Ad Fee", "Deduction Description"=>"Advertising - Quarterly Ad Billings", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/CONACT\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"CONACT\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Slotting", "Deduction Description"=>"New Item Activation Fee", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/ERNACVTN\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"ERNACVTN\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Slotting", "Deduction Description"=>"New Item Activation Fee", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/EROSF\d{4}.*/, "Invoice # Condition"=>"BEGINS WITH \"EROSF\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Shortage", "Deduction Description"=>"Over Shipment Fee", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/ERVELCTY\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"ERVELCTY\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Sales Report", "Deduction Description"=>"Velocity Report", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/WRVELCTY\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"WRVELCTY\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Sales Report", "Deduction Description"=>"Velocity Report", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/SBM\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"SBM\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Trade Shows", "Deduction Description"=>"Strategic Brands Meeting", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/URMTO.*HCM/, "Invoice # Condition"=>"BEGINS WITH \"URMTO\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"MCB", "Deduction Description"=>"URM Turnovers", "Customer Chain ID"=>"URM", "Customer Detailed Name"=>"URM"},
         {"Invoice # Format"=>/NSOWKF.*HCM/, "Invoice # Condition"=>"BEGINS WITH \"NSOWKF\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"Free Fill", "Deduction Description"=>"New Store Opening - Kowalski", "Customer Chain ID"=>"Wakefern", "Customer Detailed Name"=>"Wakefern"},
         {"Invoice # Format"=>/FSRWGM\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"FSRWGM\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Wegmans", "Customer Chain ID"=>"Wegman's", "Customer Detailed Name"=>"Wegman's"},
         {"Invoice # Format"=>/FSRWGM\w{3}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"FSRWGM\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Wegmans", "Customer Chain ID"=>"Wegman's", "Customer Detailed Name"=>"Wegman's"},
         {"Invoice # Format"=>/.*WEGMNS/, "Invoice # Condition"=>"ENDS WITH \"WEGMNS\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Wegman's", "Customer Detailed Name"=>"Wegman's"},
         {"Invoice # Format"=>/.*WINDIX/, "Invoice # Condition"=>"ENDS WITH \"WINDIX\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>nil, "Customer Chain ID"=>"Winn Dixie", "Customer Detailed Name"=>"Winn Dixie"},
         {"Invoice # Format"=>/.*WINDIXPB/, "Invoice # Condition"=>"ENDS WITH \"WINDIXPB\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>nil, "Deduction Description"=>"Payback of prior incorrect deduction", "Customer Chain ID"=>"Winn Dixie", "Customer Detailed Name"=>"Winn Dixie"},
         {"Invoice # Format"=>/KGFRSR\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"KFGRSR\"", "Parser"=>"UNFI East Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Kroger", "Customer Chain ID"=>"Kroger", "Customer Detailed Name"=>"Kroger"},
         {"Invoice # Format"=>/WFM\w{3}\d{2}.*ISEGRB/, "Invoice # Condition"=>"BEGINS WITH \"WFM\" AND ENDS WITH \"ISEGR#\"", "Parser"=>"Whole Foods In Store Execution Fee", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Off Invoice Allowance", "Deduction Description"=>"Whole Foods - In Store Execution Fee", "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/WHFDCPN.*.*/, "Invoice # Condition"=>"BEGINS WITH \"WHFDCPN\"", "Parser"=>"Whole Foods Coupons, Scans", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"MCB", "Deduction Description"=>nil, "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/WHFDADS.*.*/, "Invoice # Condition"=>"BEGINS WITH \"WHFDADS\"", "Parser"=>"Whole Foods Ad Fee", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"Ad Fee", "Deduction Description"=>nil, "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/WHFDSCAN.*.*/, "Invoice # Condition"=>"BEGINS WITH \"WHFDSCAN\"", "Parser"=>"Whole Foods Coupons, Scans", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"Scan", "Deduction Description"=>nil, "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/\d{2}\d{2}URMMCB.*CASA/, "Invoice # Condition"=>"CONTAINS \"URMMCB\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"MCB", "Deduction Description"=>"URM - MCB", "Customer Chain ID"=>"URM", "Customer Detailed Name"=>"URM"},
         {"Invoice # Format"=>/\d{2}\d{2}URMP.*CASA/, "Invoice # Condition"=>"CONTAINS \"URMP\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Ad Fee", "Deduction Description"=>"URM - Proposals", "Customer Chain ID"=>"URM", "Customer Detailed Name"=>"URM"},
         {"Invoice # Format"=>/HARMNIP\d{2}\d{4}/, "Invoice # Condition"=>"BEGINS WITH \"HARMNIP\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Slotting", "Deduction Description"=>"Harmon's New Item Placement", "Customer Chain ID"=>"Harmon's", "Customer Detailed Name"=>"Harmon's"},
         {"Invoice # Format"=>/KG.*.*CASA#/, "Invoice # Condition"=>"BEGINS WITH \"KG\" AND ENDS WITH \"CASA\"&#", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"Scan", "Deduction Description"=>"Kroger Scan", "Customer Chain ID"=>"Kroger", "Customer Detailed Name"=>"Kroger"},
         {"Invoice # Format"=>/URMTO.*HCM/, "Invoice # Condition"=>"BEGINS WITH \"URMTO\" AND ENDS WITH \"HCM\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"MCB", "Deduction Description"=>"URM Turnover", "Customer Chain ID"=>"URM", "Customer Detailed Name"=>"URM"},
         {"Invoice # Format"=>/WFM\w{3}\d{2}.*ISEGR#/, "Invoice # Condition"=>"BEGINS WITH \"WFM\" AND ENDS WITH \"ISEGR\"&#", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Off Invoice Allowance", "Deduction Description"=>"Whole Foods - In Store Execution Fee", "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/WRDC\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"WRDC\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Ad Fee", "Deduction Description"=>"Advertising - Quarterly Ad Billings", "Customer Chain ID"=>"UNFI West", "Customer Detailed Name"=>"UNFI West"},
         {"Invoice # Format"=>/WRNACVTN\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"WRNACVTN\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Slotting", "Deduction Description"=>"New Item Activation Fee", "Customer Chain ID"=>"UNFI West", "Customer Detailed Name"=>"UNFI West"},
         {"Invoice # Format"=>/WROSF\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"WROSF\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Shortage", "Deduction Description"=>"Over Shipment Fee", "Customer Chain ID"=>"UNFI West", "Customer Detailed Name"=>"UNFI West"},
         {"Invoice # Format"=>/KGFRSR\d{2}\d{2}.*/, "Invoice # Condition"=>"BEGINS WITH \"KFGRSR\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Merchandising", "Deduction Description"=>"Fair Share - Kroger", "Customer Chain ID"=>"Kroger", "Customer Detailed Name"=>"Kroger"},
         {"Invoice # Format"=>/WRCRDMCB.*/, "Invoice # Condition"=>"BEGINS WITH \"WRCRDMCB\"", "Parser"=>"UNFI West Deduction Invoice", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"MCB", "Deduction Description"=>"MCB - Missed Deduction", "Customer Chain ID"=>"UNFI West", "Customer Detailed Name"=>"UNFI West"},
         {"Invoice # Format"=>/WFM\w{3}\d{2}.*ISEGRB/, "Invoice # Condition"=>"BEGINS WITH \"WFM\" AND ENDS WITH \"ISEGR#\"", "Parser"=>"Whole Foods In Store Execution Fee", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Off Invoice Allowance", "Deduction Description"=>"Whole Foods - In Store Execution Fee", "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/WHFDCPN.*.*/, "Invoice # Condition"=>"BEGINS WITH \"WHFDCPN\"", "Parser"=>"Whole Foods Coupons, Scans", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"MCB", "Deduction Description"=>nil, "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/WHFDADS.*.*/, "Invoice # Condition"=>"BEGINS WITH \"WHFDADS\"", "Parser"=>"Whole Foods Ad Fee", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"Ad Fee", "Deduction Description"=>nil, "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/WHFDSCAN.*.*/, "Invoice # Condition"=>"BEGINS WITH \"WHFDSCAN\"", "Parser"=>"Whole Foods Coupons, Scans", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"Scan", "Deduction Description"=>nil, "Customer Chain ID"=>"Whole Foods", "Customer Detailed Name"=>"Whole Foods"},
         {"Invoice # Format"=>/PLC\w{3}\d{2}.*CASA/, "Invoice # Condition"=>"BEGINS WITH \"PLC\"", "Parser"=>"UNFI West Product Loss Claims Report", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Spoilage", "Deduction Description"=>"Spoilage - Product Loss Claims Report", "Customer Chain ID"=>"UNFI West", "Customer Detailed Name"=>"UNFI West"},
         {"Invoice # Format"=>/MVPDMW.*/, "Invoice # Condition"=>"BEGINS WITH \"MVPDMW\"", "Parser"=>"UNFI West Vendor Billback Form", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"MCB", "Deduction Description"=>nil, "Customer Chain ID"=>"UNFI West", "Customer Detailed Name"=>"UNFI West"},
         {"Invoice # Format"=>/MVPDME.*/, "Invoice # Condition"=>"BEGINS WITH \"MVPDME\"", "Parser"=>"UNFI East Vendor Billback Form", "Promo Start Date"=>nil, "Promo End Date"=>nil, "Deduction Type"=>"MCB", "Deduction Description"=>nil, "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/OVP\d{2}\d{2}.*TXAU/, "Invoice # Condition"=>"BEGINS WITH \"OVP\"", "Parser"=>"UNFI West Overpull Supplier Billing Report", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"MCB", "Deduction Description"=>"UNFI West Overpull Supplier Billing Report", "Customer Chain ID"=>"UNFI West", "Customer Detailed Name"=>"UNFI West"},
         {"Invoice # Format"=>/01OVP\d{2}\d{2}.*TXAU/, "Invoice # Condition"=>"BEGINS WITH \"01OVP\"", "Parser"=>"UNFI East Overpull Supplier Billing Report", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"MCB", "Deduction Description"=>"UNFI East Overpull Supplier Billing Report", "Customer Chain ID"=>"UNFI East", "Customer Detailed Name"=>"UNFI East"},
         {"Invoice # Format"=>/\d{2}\d{2}NCG.*CASA/, "Invoice # Condition"=>"CONTAINS \"NCG\"", "Parser"=>"NCG Deduction Form", "Promo Start Date"=>"(mm)/01/(yyyy)", "Promo End Date"=>"last day of applicable month", "Deduction Type"=>"Ad Fee", "Deduction Description"=>"NCG - Ad Fee", "Customer Chain ID"=>"NCG", "Customer Detailed Name"=>"NCG"}
       ]

        def get_invoice_number_lookup(invoice_number)
          INVOICE_NUMBER_TO_DEDUCTION_CUSTOMER_LOOKUP.each do |lookup|
            regex = lookup['Invoice # Format']
            return lookup if invoice_number.try(:match?, regex)
          end

          { "Invoice # Format"=>"N/A in Invoice Number Lookup",
            "Invoice # Condition"=>"N/A in Invoice Number Lookup",
            "Parser"=>"N/A in Invoice Number Lookup",
            "Promo Start Date"=>"N/A in Invoice Number Lookup",
            "Promo End Date"=>"N/A in Invoice Number Lookup",
            "Deduction Type"=>"N/A in Invoice Number Lookup",
            "Deduction Description"=>"N/A in Invoice Number Lookup",
            "Customer Chain ID"=>"N/A in Invoice Number Lookup",
            "Customer Detailed Name"=>"N/A in Invoice Number Lookup"
          }
        end
      end
    end
  end
end