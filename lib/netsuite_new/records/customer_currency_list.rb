module NetSuiteNew
  module Records
    class CustomerCurrencyList < Support::Sublist
      include Namespaces::ListRel

      sublist :currency, NetSuiteNew::Records::CustomerCurrency
    end
  end
end
