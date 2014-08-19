class BulkOutWorker
  include Sidekiq::Worker

  def perform(contacts, msg, user_id)

    contacts.each do |x|

      #log the sms
      @sms_log = SmsLog.new
      @sms_log.cell_number = x
      @sms_log.message = msg
      @sms_log.status = "Sending"
      @sms_log.user_id = user_id

      if @sms_log.save!

        #send sms
        @send_response = SendSMS.new
        @send_response.momt = "MT"
        @send_response.sender = "SCC"
        @send_response.receiver = x
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