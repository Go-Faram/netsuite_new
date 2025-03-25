module NetSuiteNew
  module Records
    class TranslationList < Support::Sublist
      include NetSuiteNew::Namespaces::ListAcct

      sublist :translation, NetSuiteNew::Records::Translation

      alias translations translation
    end
  end
end
