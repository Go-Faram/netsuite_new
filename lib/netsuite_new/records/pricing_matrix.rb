module NetSuiteNew
  module Records
    class PricingMatrix < Support::Sublist
      include NetSuiteNew::Namespaces::ListAcct

      sublist :pricing, NetSuiteNew::Records::Pricing

      alias :prices :pricing
    end
  end
end
