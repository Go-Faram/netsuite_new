module NetSuiteNew
  module Actions
    class GetDeleted < AbstractAction
      include Support::Requests

      def initialize(object = nil, options = {})
        @object  = object
        @options = options
      end

      private

      def soap_type
        NetSuiteNew::Support::Records.netsuite_type(@object)
      end

      # <soap:Body>
      #   <platformMsgs:getDeleted>
      #     <platformMsgs:pageIndex>1</platformMsgs:pageIndex>
      #     <platformMsgs:getDeletedFilter>
      #       <platformCore:deletedDate operator="within">
      #         <platformCore:searchValue>2016-12-01T00:00:00</platformCore:searchValue>
      #         <platformCore:searchValue2>2016-12-20T00:00:00</platformCore:searchValue2>
      #       </platformCore:deletedDate>
      #       <platformCore:type operator="anyOf">
      #         <platformCore:searchValue>invoice</platformCore:searchValue>
      #       </platformCore:type>
      #     </platformMsgs:getDeletedFilter>
      #   </platformMsgs:getDeleted>
      # </soap:Body>
      def request_body
        criteria = @options[:criteria] || @options
        filter_elements = {}

        criteria.each do |c|
          searchValue = { "@operator" => c[:operator] }

          if c[:value].is_a?(Array) && c[:type] == 'SearchDateField'
            searchValue["platformCore:searchValue"] = c[:value][0].to_s
            searchValue["platformCore:searchValue2"] = c[:value][1].to_s
          else
            searchValue["platformCore:searchValue"] = c[:value]
          end

          filter_elements["platformCore:#{c[:field]}"] = searchValue
        end

        {
          'platformMsgs:pageIndex' => @options.fetch(:page, 1),
          'platformMsgs:getDeletedFilter' => filter_elements
        }
      end

      def response_hash
        @response.body[:get_deleted_response]
      end

      def success?
        @success ||= response_body[:status][:@is_success] == 'true'
      end

      def response_body
        @response_body ||= response_hash[:get_deleted_result]
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
        :get_deleted
      end

      module Support
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def get_deleted(options = { }, credentials={})
            NetSuiteNew::Actions::GetDeleted.call([self, options], credentials)
          end
        end
      end
    end
  end
end
