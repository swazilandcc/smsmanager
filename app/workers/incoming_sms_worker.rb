class IncomingSmsWorker
  require 'net/http'
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

        #@send_response = SendSMS.new
        #@send_response.momt = "MT"
        #@send_response.sender = "7070"
        #@send_response.receiver = sender
        #@send_response.msgdata = mess
        #@send_response.sms_type = 2

        url = URI.parse("http://localhost:13013/cgi-bin/sendsms?username=smsmanager&password=P5ssw0rd&from=7070&to=#{sender}&text=#{message_to_send}&dlr-mask=1+2")
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        if res.body.to_s.match("Accepted for delivery").nil? == false

          @incoming_message.reply_message = @send_response.msgdata
          @incoming_message.reply_sent = true
          @incoming_message.reply_sent_date_time = Time.now
          @incoming_message.save!

        end



        #http://localhost:13013/cgi-bin/sendsms?username=smsmanager&password=P5ssw0rd&from=7070&to=+26876024130+26876612160&text=Hello+world&dlr-mask=1+2

        #if @send_response.save!
        #
        #
        #
        #end



      end

    end

  end

end
