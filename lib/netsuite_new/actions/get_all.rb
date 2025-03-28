# https://system.netsuite.com/help/helpcenter/en_US/Output/Help/SuiteCloudCustomizationScriptingWebServices/SuiteTalkWebServices/getAll.html
module NetSuiteNew
  module Actions
    class GetAll < AbstractAction
      include Support::Requests

      def initialize(klass)
        @klass   = klass
      end

      private

      # <soap:Body>
      #   <platformMsgs:getAll>
      #     <record>
      #       <recordType>salesTaxItem</recordType>
      #     </record>
      #   </platformMsgs:getAll>
      # </soap:Body>
      def request_body
        type = @klass.to_s.split('::').last.sub(/[A-Z]/) { |m| m[0].downcase }

        {
          record: [
            record_type: type
          ]
        }
      end

      def success?
        @success ||= response_hash[:status][:@is_success] == 'true'
      end

      def response_body
        @response_body ||= if success?
          array_wrap(response_hash[:record_list][:record])
        else
          nil
        end
      end

      def response_hash
        @response_hash ||= @response.body[:get_all_response][:get_all_result]
      end

      def request_options
        {
          element_form_default: :unqualified
        }
      end

      def action_name
        :get_all
      end

      module Support

        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def get_all(credentials = {})
            response = NetSuiteNew::Actions::GetAll.call([self], credentials)

            # TODO expose errors to the user

            if response.success?
              response.body.map { |attr| new(attr) }
            else
              false
            end
          end
        end
      end
    end
  end
end
