class IncomingSmsWorker
  require 'net/http'
  include Sidekiq::Worker

  def perform(sender, keyword, option, extra_text, message_to_send)

    if (sender.nil? == false)

      @cleaned_up_keyword = keyword.to_s.upcase.strip! rescue nil

      @competition = Competition.where("active = 1 AND keyword = #{@cleaned_up_keyword} AND end_date >= #{Time.now.strftime("%Y-%m-%d")}").first

      if @competition.nil? == false

        @incoming_message = IncomingMessage.new

        if @competition.competition_options.exists? == true && option.nil? == false

           @competition.competition_options.each do |x|

              if option == x.option_number

                @matches_option = true

              else

                @matches_option = false

              end

           end

        end

        @incoming_message.sender = sender
        @incoming_message.keyword = keyword
        @incoming_message.option = option
        @incoming_message.extra_text = extra_text
        @incoming_message.matched_to_competition = true
        @incoming_message.competition_id  = @competition.id
        @incoming_message.matched_to_devotional = false

        if @incoming_message.save!

          @send_response = SendSMS.new
          @send_response.momt = "MT"
          @send_response.sender = "7070"
          @send_response.receiver = sender

          if @matches_option = true

            @send_response.msgdata = @competition.success_message

          else

            @send_response.msgdata = @competition.incorrect_option_message

          end

          @send_response.sms_type = 2

          if @send_response.save!

            @incoming_message.reply_message = @send_response.msgdata
            @incoming_message.reply_sent = true
            @incoming_message.reply_sent_date_time = Time.now
            @incoming_message.save!

          end

        end


      else

        @incoming_message = IncomingMessage.new

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

end
