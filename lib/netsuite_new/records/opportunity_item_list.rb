module NetSuiteNew
  module Records
    class OpportunityItemList < Support::Sublist
      include Namespaces::TranSales

      sublist :item, OpportunityItem
    end
  end
end
