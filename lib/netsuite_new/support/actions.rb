module NetSuiteNew
  module Support
    module Actions

      attr_accessor :errors

      def self.included(base)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods

        def actions(*args)
          args.each do |action|
            action(action)
          end
        end

        def action(name)
          case name
          when :attach_file
            self.send(:include, NetSuiteNew::Actions::AttachFile::Support)
          when :get
            self.send(:include, NetSuiteNew::Actions::Get::Support)
          when :get_all
            self.send(:include, NetSuiteNew::Actions::GetAll::Support)
          when :get_deleted
            self.send(:include, NetSuiteNew::Actions::GetDeleted::Support)
          when :get_list
            self.send(:include, NetSuiteNew::Actions::GetList::Support)
          when :get_select_value
            self.send(:include, NetSuiteNew::Actions::GetSelectValue::Support)
          when :search
            self.send(:include, NetSuiteNew::Actions::Search::Support)
          when :add
            self.send(:include, NetSuiteNew::Actions::Add::Support)
          when :upsert
            self.send(:include, NetSuiteNew::Actions::Upsert::Support)
          when :upsert_list
            self.send(:include, NetSuiteNew::Actions::UpsertList::Support)
          when :delete
            self.send(:include, NetSuiteNew::Actions::Delete::Support)
          when :delete_list
            self.send(:include, NetSuiteNew::Actions::DeleteList::Support)
          when :update
            self.send(:include, NetSuiteNew::Actions::Update::Support)
          when :update_list
            self.send(:include, NetSuiteNew::Actions::UpdateList::Support)
          when :initialize
            self.send(:include, NetSuiteNew::Actions::Initialize::Support)
          else
            raise "Unknown action: #{name.inspect}"
          end
        end

      end

    end
  end
end
