module NetSuiteNew
  module Records
    class VendorPaymentApply
      include Support::Fields
      include Support::Records
      include Namespaces::TranPurch

      fields :amount, :apply, :apply_date, :currency, :disc, :disc_amt, :disc_date, :doc,
        :due, :line, :job, :ref_num, :total, :type

      def initialize(attributes = {})
        initialize_from_attributes_hash(attributes)
      end
    end
  end
end
