module NetSuiteNew
  module Records
    class ItemFulfillmentPackage
      include Support::Fields
      include Support::Records
      include Namespaces::TranSales

      fields :package_weight, :package_descr, :package_tracking_number

      def initialize(attributes_or_record = {})
        case attributes_or_record
        when Hash
          initialize_from_attributes_hash(attributes_or_record)
        when self.class
          initialize_from_record(attributes_or_record)
        end
      end

      def initialize_from_record(record)
        self.attributes = record.send(:attributes)
      end
    end
  end
end
