module NetSuiteNew
  module Actions
    class AttachFile < AbstractAction
      include Support::Requests

      def initialize(object, file)
        @object = object
        @file   = file
      end

      private

      # <soap:Body>
      #   <platformMsgs:attach>
      #     <platformCore:attachReference xsi:type="platformCore:AttachContactReference">
      #       <platformCore::attachTo internalId="176" type="customer" xsi:type="platformCore::RecordRef">
      #       </platformCore:attachTo>
      #       <platformCore:attachRecord internalId="1467" type="file" xsi:type="platformCore:RecordRef"/>
      #     </platformCore:attachReference>
      #   </platformMsgs:attach>
      # </soap:Body>

      def request_body
        {
          'platformCore:attachReference' => {
            '@xsi:type' => 'platformCore:AttachBasicReference',
            'platformCore:attachTo' => {
              '@internalId' => @object.internal_id,
              '@type' => @object.netsuite_type,
              '@xsi:type' => 'platformCore:RecordRef'
            },
            'platformCore:attachedRecord' => {
              '@internalId' => @file.internal_id,
              '@type' => 'file',
              '@xsi:type' => 'platformCore:RecordRef'
            }
          }
        }
      end

      def success?
        @success ||= response_hash[:status][:@is_success] == 'true'
      end

      def response_body
        @response_body ||= response_hash[:base_ref]
      end

      def response_errors
        if response_hash[:status] && response_hash[:status][:status_detail]
          @response_errors ||= errors
        end
      end

      def response_hash
        @response_hash ||= @response.to_hash[:attach_response][:write_response]
      end

      def action_name
        :attach
      end

      def errors
        error_obj = response_hash[:status][:status_detail]
        error_obj = [error_obj] if error_obj.class == Hash
        error_obj.map do |error|
          NetSuiteNew::Error.new(error)
        end
      end

      module Support
        def attach_file(file, credentials = {})
          response = NetSuiteNew::Actions::AttachFile.call([self, file], credentials)

          @errors = response.errors

          if response.success?
            @internal_id = response.body[:@internal_id]
            true
          else
            false
          end
        end
      end
    end
  end
end
