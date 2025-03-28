module NetSuiteNew
  module Actions
    class DeleteList < AbstractAction
      include Support::Requests

      def initialize(klass, options = { })
        @klass = klass
        @options = options
      end

      private

      # <soap:Body>
      #   <platformMsgs:deleteList>
      #     <platformMsgs:baseRef internalId="1" type="customer" xsi:type="platformCore:RecordRef"/>
      #     <platformMsgs:baseRef internalId="2" type="customer" xsi:type="platformCore:RecordRef"/>
      #   </platformMsgs:deleteList>
      # </soap:Body>
      def request_body
        list = @options.is_a?(Hash) ? @options[:list] : @options

        formatted_list = if @options[:type_id]
          type_id = @options[:type_id]
          record_type = 'platformCore:CustomRecordRef'

          list.map do |internal_id|
            {
              '@internalId' => internal_id,
              '@typeId' => type_id,
              '@xsi:type' => record_type
            }
          end
        else
          type = NetSuiteNew::Support::Records.netsuite_type(@klass)
          record_type = 'platformCore:RecordRef'

          list.map do |internal_id|
            {
              '@internalId' => internal_id,
              '@type' => type,
              '@xsi:type' => record_type
            }
          end
        end

        {
          baseRef: formatted_list
        }
      end

      def response_list
        @response_list ||= array_wrap(@response.to_hash[:delete_list_response][:write_response_list][:write_response])
      end

      def success?
        @success ||= response_errors.blank?
      end

      def response_errors
        if response_list.any? { |r| r[:status][:@is_success] == 'false' }
          @response_errors ||= errors
        end
      end

      def request_options
        {
          namespaces: {
          'xmlns:platformMsgs' => "urn:messages_#{NetSuiteNew::Configuration.api_version}.platform.webservices.netsuite.com",
          'xmlns:platformCore' => "urn:core_#{NetSuiteNew::Configuration.api_version}.platform.webservices.netsuite.com"
          }
        }
      end

      def action_name
        :delete_list
      end

      def errors
        errors = response_list.select { |r| r[:status] && r[:status][:status_detail] }.map do |obj|
          error_obj = obj[:status][:status_detail]
          error_obj = [error_obj] if error_obj.class == Hash
          errors = error_obj.map do |error|
            NetSuiteNew::Error.new(error)
          end

          [obj[:base_ref][:@internal_id], errors]
        end
        Hash[errors]
      end

      def response_body
        @response_body ||= response_list
      end

      module Support
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def delete_list(options = { }, credentials={})
            response = NetSuiteNew::Actions::DeleteList.call([self, options], credentials)
          end
        end
      end
    end
  end
end