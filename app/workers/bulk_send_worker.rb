class BulkSendWorker
  include Sidekiq::Worker

  def perform(group_id, msg, user_id, send_bulk_id)

    group_contacts = ContactsGroup.find_all_by_group_id(group_id)

    group_contacts.each do |x|
      contact_cell_number = x.contact.cell_number

      #log the sms
      @sms_log = SmsLog.new
      @sms_log.cell_number = contact_cell_number
      @sms_log.message = msg
      @sms_log.status = "Sending"
      @sms_log.user_id = user_id

      bulk_send = SendBulkMessage.find(send_bulk_id)
      bulk_send.status = "Sending"
      bulk_send.save!

      if @sms_log.save!

        #send sms
        @send_response = SendSMS.new
        @send_response.momt = "MT"
        @send_response.sender = "SCC"
        @send_response.receiver = contact_cell_number
        @send_response.msgdata = msg
        @send_response.sms_type = 2

        if @send_response.save!

          @sms_log.status = "Sent"
          bulk_send.status = "Sent"
          bulk_send.save!

        end


      end

    end

  end

end