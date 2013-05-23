class IncomingSmsWorker
  require 'net/http'
  include Sidekiq::Worker

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

      @competition = Competition.where("keyword = '#{keyword.to_s.strip.upcase}'").first

      if @competition.active? == true && @competition.end_date >= Time.now.strftime("%Y-%m-%d")

        if @competition.nil? == false

          # We have found a matching keyword from the senders text

          @competition_options = @competition.competition_options.where("option_number = #{option.to_i}").first

          if @competition_options.nil? == false


            # The Sender Has the right competition keyword and the option is right
            @incoming_message.matched_to_competition = true
            @incoming_message.competition_id = @competition.id
            @incoming_message.reply_message = @competition.success_message

            if @incoming_message.save!


              @send_response.msgdata = @competition.success_message
              @send_response.sms_type = 2

              if @send_response.save!


                @incoming_message.reply_sent = true
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              end


            end

          elsif @competition_options.nil? == true && @competition.competition_options.exists? == false

            # There was not option defined for the competition so this is considered as a successful message
            @incoming_message.matched_to_competition = false
            @incoming_message.matched_to_devotional = false
            @incoming_message.reply_message = message_to_send

            if @incoming_message.save!


              @send_response.msgdata = @competition.success_message
              @send_response.sms_type = 2

              if @send_response.save!


                @incoming_message.reply_sent = true
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              end


            end


          else

            # The Sender Has the right competition keyword but the option is wrong
            @incoming_message.matched_to_competition = true
            @incoming_message.competition_id = @competition.id
            @incoming_message.reply_message = @competition.incorrect_option_message

            if @incoming_message.save!


              @send_response.msgdata = @competition.incorrect_option_message
              @send_response.sms_type = 2

              if @send_response.save!


                @incoming_message.reply_sent = true
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              end


            end


          end


        else

          # We could not find any competition to match the received text ... so we send thank you
          @incoming_message.matched_to_competition = false
          @incoming_message.matched_to_devotional = false
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


      else


        # The competition is either inactive or is now closed
        @incoming_message.matched_to_competition = false
        @incoming_message.matched_to_devotional = false
        @incoming_message.reply_message = @competition.closed_message.to_s + "[CLOSED]"

        if @incoming_message.save!


          @send_response.msgdata = @competition.closed_message
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
