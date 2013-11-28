class DailyVerseWorker
  include Sidekiq::Worker

  require 'net/http'
  require 'uri'

  def perform(sender, keyword, option, extra_text, message_to_send)


    if sender.nil? == false

      # Prepare incoming message log
      @incoming_message = IncomingMessage.new
      @incoming_message.sender = sender
      @incoming_message.keyword = keyword
      @incoming_message.option = option
      @incoming_message.extra_text = extra_text

      # Prepare Response
      @send_response = SendSMS.new
      @send_response.momt = "MT"
      @send_response.sender = "7070"
      @send_response.receiver = sender

      # Get Daily Devotional Message
      uri = URI.parse("http://www.ourmanna.com/verses/api/get/?format=text&order=random")

      # Full
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.request(Net::HTTP::Get.new(uri.request_uri)) rescue nil

      if response.nil? == false

        if response.body.to_s.length > 160

          verse = response.body.to_s.split(" - ")
          verse[0] = verse[0].to_s.truncate(response.body.to_s.length - 161)

          sms = verse[0] + "#" + verse[1]

          @incoming_message.matched_to_competition = false
          @incoming_message.matched_to_devotional = true
          @incoming_message.reply_message = sms

          if @incoming_message.save!

            @send_response.msgdata = sms
            @send_response.sms_type = 2

            if @send_response.save!

              @incoming_message.reply_sent = true
              @incoming_message.reply_sent_date_time = Time.now
              @incoming_message.save!

            end

          end

        else

          sms = response.body.to_s

          @incoming_message.matched_to_competition = false
          @incoming_message.matched_to_devotional = true
          @incoming_message.reply_message = sms

          if @incoming_message.save!

            @send_response.msgdata = sms
            @send_response.sms_type = 2

            if @send_response.save!

              @incoming_message.reply_sent = true
              @incoming_message.reply_sent_date_time = Time.now
              @incoming_message.save!

            end

          end

        end

      else

        @incoming_message.matched_to_competition = false
        @incoming_message.matched_to_devotional = true
        @incoming_message.reply_message = message_to_send

        if @incoming_message.save!

          @send_response.msgdata = message_to_send
          @send_response.sms_type = 2

          if @send_response.save!

            @incoming_message.reply_sent = true
            @incoming_message.reply_sent_date_time = Time.now
            @incoming_message.save!

          end

        end

      end

    end


  end

end