class IncomingSmsWorker
  include Sidekiq::Worker

  def perform(sender, keyword, option, extra_text, message_to_send)

    @incoming_message = IncomingMessage.new

    if (sender.nil? == false)

      @incoming_message.sender = sender
      @incoming_message.keyword = keyword
      @incoming_message.option = option
      @incoming_message.extra_text = extra_text
      @incoming_message.matched_to_competition = false
      @incoming_message.matched_to_devotional = false

      if @incoming_message.save!

        @send_response = SendSMS.new
        @send_response.momt = "MT"
        @send_response.sender = "7070"
        @send_response.receiver = sender
        @send_response.msgdata = message_to_send
        @send_response.sms_type = 2

        if @send_response.save!

          @incoming_message.reply_message = @send_response.msgdata
          @incoming_message.reply_sent = true
          @incoming_message.reply_sent_date_time = Time.now
          @incoming_message.save!

        end

      end

    end

  end

end
