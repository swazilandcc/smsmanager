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

      @competition = Competition.where(:keyword => keyword.to_s.strip.upcase).first

      if @competition.nil? == false

        if @competition.active? == true && @competition.end_date.strftime("%Y-%m-%d") >= Time.now.strftime("%Y-%m-%d") && @competition.start_date.strftime("%Y-%m-%d") <= Time.now.strftime("%Y-%m-%d")

          # We have found a matching keyword from the senders text

          @competition_options = @competition.competition_options.where(:option_number => option.to_i).first

          if @competition_options.nil? == false

            @rndString = ''

            if @competition.response_include_serial == true
              o =  [('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
              @rndString = "#".to_s + (0...5).map{ o[rand(o.length)] }.join.to_s
            end

            # The Sender Has the right competition keyword and the option is right
            @incoming_message.matched_to_competition = true
            @incoming_message.matched_to_quiz = false
            @incoming_message.matched_to_devotional = false
            @incoming_message.competition_id = @competition.id
            @incoming_message.reply_message = @competition.success_message.to_s + @rndString.to_s

            if @incoming_message.save!

              @message_to_send = ""

              if @competition.send_special_message.nil? == false

                if @competition.send_special_message == true

                  sms_count = IncomingMessage.find_all_by_sender_and_keyword(sender, keyword.to_s.strip.upcase).count

                  if @competition.special_message_incoming_count == sms_count

                    @message_to_send = @competition.special_message_content

                  else

                    @message_to_send = @competition.success_message.to_s + @rndString.to_s

                  end

                end

              else

                @message_to_send = @competition.success_message.to_s + @rndString.to_s

              end

              @send_response.msgdata = @message_to_send
              @send_response.sms_type = 2

              if @send_response.save!


                @incoming_message.reply_sent = true
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              end


            end

          elsif @competition_options.nil? == true && @competition.competition_options.exists? == false


            @rndString = ''

            if @competition.response_include_serial == true
              o =  [('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
              @rndString = "#".to_s + (0...5).map{ o[rand(o.length)] }.join.to_s
            end

            # There was not option defined for the competition so this is considered as a successful message
            @incoming_message.matched_to_competition = true
            @incoming_message.matched_to_quiz = false
            @incoming_message.matched_to_devotional = false
            @incoming_message.competition_id = @competition.id
            @incoming_message.reply_message = @competition.success_message.to_s + @rndString.to_s

            if @incoming_message.save!

              @message_to_send = ""

              if @competition.send_special_message.nil? == false

                if @competition.send_special_message == true

                  sms_count = IncomingMessage.find_all_by_sender_and_keyword(sender, keyword.to_s.strip.upcase).count

                  if @competition.special_message_incoming_count == sms_count

                    @message_to_send = @competition.special_message_content

                  else

                    @message_to_send = @competition.success_message.to_s + @rndString.to_s

                  end

                end

              else

                @message_to_send = @competition.success_message.to_s + @rndString.to_s


              end


              @send_response.msgdata = @message_to_send
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

        elsif @competition.active? == true && @competition.end_date.strftime("%Y-%m-%d") >= Time.now.strftime("%Y-%m-%d") && @competition.start_date.strftime("%Y-%m-%d") > Time.now.strftime("%Y-%m-%d")
          # The competition hasn't started yet ... notify the sender
          @incoming_message.matched_to_competition = true
          @incoming_message.matched_to_devotional = false
          @incoming_message.matched_to_quiz = false
          @incoming_message.competition_id = @competition.id
          @incoming_message.reply_message = "SMS entry for #{@competition.keyword} is not open yet. Please try again on the #{@competition.start_date.strftime("%d-%m-%Y")}. Thank you.[PRE]"

          if @incoming_message.save!


            @send_response.msgdata = "SMS entry for #{@competition.keyword} is not open yet. Please try again on the #{@competition.start_date.strftime("%d-%m-%Y")}. Thank you."
            @send_response.sms_type = 2

            if @send_response.save!


              @incoming_message.reply_sent = true
              @incoming_message.reply_sent_date_time = Time.now
              @incoming_message.save!

            end


          end


        else

          # The competition is either inactive or is now closed
          @incoming_message.matched_to_competition = false
          @incoming_message.matched_to_devotional = false
          @incoming_message.matched_to_quiz = false
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

      else

        # We could not find any competition to match the received text ... so we send thank you
        @incoming_message.matched_to_competition = false
        @incoming_message.matched_to_devotional = false
        @incoming_message.matched_to_quiz = false
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
