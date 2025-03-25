module NetSuiteNew
  module Records
    class VendorCurrencyList < Support::Sublist
      include Namespaces::ListRel

      sublist :vendor_currency, NetSuiteNew::Records::VendorCurrency
    end
  end
end
