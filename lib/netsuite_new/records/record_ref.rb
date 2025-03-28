module NetSuiteNew
  module Records
    class RecordRef
      include Support::Fields
      include Support::Records
      include Namespaces::PlatformCore

      attr_reader   :internal_id, :type
      attr_accessor :external_id

      def initialize(attributes_or_record = {})
        case attributes_or_record
        when Hash
          attributes = attributes_or_record
          attributes.delete(:"@xmlns:platform_core")
          @internal_id = attributes.delete(:internal_id) || attributes.delete(:@internal_id)
          @external_id = attributes.delete(:external_id) || attributes.delete(:@external_id)
          @type        = attributes.delete(:type) || attributes.delete(:@type) || attributes.delete(:"@xsi:type")
          @attributes  = attributes
        else
          record = attributes_or_record
          @internal_id = record.internal_id if record.respond_to?(:internal_id)
          @external_id = record.external_id if record.respond_to?(:external_id)
          @type        = NetSuiteNew::Support::Records.netsuite_type(record)
        end
      end

      def method_missing(m, *args, &block)
        if attributes.keys.map(&:to_sym).include?(m.to_sym)
          attributes[m.to_sym]
        else
          super
        end
      end

    end
  end
end
