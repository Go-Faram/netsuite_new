module NetSuiteNew
  module Records
    class CustomerSalesTeamList < Support::Sublist
      include Namespaces::ListRel

      sublist :sales_team, NetSuiteNew::Records::CustomerSalesTeam
    end
  end
end
