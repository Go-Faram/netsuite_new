module NetSuiteNew
  module Records
    class CustomerPartnersList < Support::Sublist
      include Namespaces::ListRel

      sublist :partners, NetSuiteNew::Records::CustomerPartner
    end
  end
end
