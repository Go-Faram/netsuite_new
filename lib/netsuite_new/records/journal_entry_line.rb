module NetSuiteNew
  module Records
    class JournalEntryLine
      include Support::Fields
      include Support::RecordRefs
      include Support::Records
      include Namespaces::TranGeneral

      fields :credit, :debit, :eliminate, :end_date, :gross_amt, :memo, :residual, :start_date, :tax1_amt, :tax_rate1
      field :custom_field_list, CustomFieldList
      record_refs :account, :department, :entity, :klass, :location, :schedule, :schedule_num, :tax1_acct, :tax_code

      def initialize(attributes = {})
        initialize_from_attributes_hash(attributes)
      end

      def to_record
        rec = super
        if rec["#{record_namespace}:customFieldList"]
          rec["#{record_namespace}:customFieldList!"] = rec.delete("#{record_namespace}:customFieldList")
        end
        rec
      end

    end
  end
end
