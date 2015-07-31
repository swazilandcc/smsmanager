class IncomingSmsWorker
  require 'net/http'
  include Sidekiq::Worker

  def perform(sender, keyword, option, extra_text, message_to_send, short_code)

    ## Make sure the sender is not empty
    if sender.nil? == false

      # Prepare incoming message log
      @incoming_message = IncomingMessage.new
      @incoming_message.sender = sender
      @incoming_message.keyword = keyword
      @incoming_message.option = option
      @incoming_message.extra_text = extra_text
      @incoming_message.short_code = short_code

      # Prepare Response
      @send_response = SendSMS.new
      @send_response.momt = "MT"
      @send_response.sender = short_code
      @send_response.receiver = sender

      @competition = Competition.where(:keyword => keyword.to_s.strip.upcase).first rescue nil

      if @competition.nil? == false
        ### The compeition is found continute to check if it is active

        @rndString = ''
        if @competition.response_include_serial == true
          o =  [('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
          @rndString = "#".to_s + (0...5).map{ o[rand(o.length)] }.join.to_s
        end


        if @competition.active? == true
          ### The compeition is active so continue to check if it has not been closed

          if @competition.start_date.strftime("%Y-%m-%d") <= Time.now.strftime("%Y-%m-%d") && @competition.end_date.strftime("%Y-%m-%d") >= Time.now.strftime("%Y-%m-%d")
            ## The competition is open and the end date has not been reached yet
            if @competition_options.nil? == true && @competition.competition_options.exists? == false
              ## The competition does not have any options enabled

              @incoming_message.matched_to_competition = true
              @incoming_message.matched_to_quiz = false
              @incoming_message.matched_to_devotional = false
              @incoming_message.competition_id = @competition.id

              ## Check if random serial needs to be included in the response message
              if @competition.response_include_serial == true
                @incoming_message.reply_message = @competition.success_message.to_s + @rndString.to_s
              else
                @incoming_message.reply_message = @competition.success_message.to_s
              end


              @message_to_send = ""
              if @incoming_message.save!

                ## Check if there is a special message we need to send
                if @competition.send_special_message.nil? == false

                  if @competition.send_special_message == true
                    sms_count = IncomingMessage.find_all_by_sender_and_keyword(sender, keyword.to_s.strip.upcase).count

                    if @competition.special_message_incoming_count.to_i == sms_count

                      @message_to_send = @competition.special_message_content

                    else

                      @message_to_send = @incoming_message.reply_message

                    end

                  else

                    @message_to_send = @incoming_message.reply_message

                  end

                else

                  @message_to_send = @incoming_message.reply_message

                end

              end

              @send_response.msgdata = @message_to_send
              @send_response.sms_type = 2

              if @send_response.save!

                @incoming_message.reply_sent = true
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              else

                @incoming_message.reply_sent = false
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              end

            elsif @competition_options.nil? == false && @competition.competition_options.exists? == true
              ## The competition does have options enabled and options are found
              @competition_options = @competition.competition_options.where(:option_number => option.to_i).first rescue nil

              if @competition_options.nil? == false
                ### The sender has selected one of the available options
                @incoming_message.matched_to_competition = true
                @incoming_message.matched_to_quiz = false
                @incoming_message.matched_to_devotional = false
                @incoming_message.competition_id = @competition.id

                if @competition.response_include_serial == true
                  @incoming_message.reply_message = @competition.success_message.to_s + @rndString.to_s
                else
                  @incoming_message.reply_message = @competition.success_message.to_s
                end

                @message_to_send = ""
                if @incoming_message.save!

                  ## Check if there is a special message we need to send
                  if @competition.send_special_message.nil? == false

                    if @competition.send_special_message == true
                      sms_count = IncomingMessage.find_all_by_sender_and_keyword(sender, keyword.to_s.strip.upcase).count

                      if @competition.special_message_incoming_count == sms_count

                        @message_to_send = @competition.special_message_content

                      else

                        @message_to_send = @incoming_message.reply_message

                      end

                    else

                      @message_to_send = @incoming_message.reply_message

                    end

                  else

                    @message_to_send = @incoming_message.reply_message

                  end

                end

                @send_response.msgdata = @message_to_send
                @send_response.sms_type = 2

                if @send_response.save!

                  @incoming_message.reply_sent = true
                  @incoming_message.reply_sent_date_time = Time.now
                  @incoming_message.save!

                else

                  @incoming_message.reply_sent = false
                  @incoming_message.reply_sent_date_time = Time.now
                  @incoming_message.save!

                end



              else
                ### The sender has specified a non existing option
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

                  else

                    @incoming_message.reply_sent = false
                    @incoming_message.reply_sent_date_time = Time.now
                    @incoming_message.save!

                  end


                end


              end


            elsif @competition_options.nil? == false && @competition.competition_options.exists? == false
              ## The competition does have options enable but there are not options found
              @incoming_message.matched_to_competition = true
              @incoming_message.matched_to_quiz = false
              @incoming_message.matched_to_devotional = false
              @incoming_message.competition_id = @competition.id

              if @competition.response_include_serial == true
                @incoming_message.reply_message = @competition.success_message.to_s + @rndString.to_s
              else
                @incoming_message.reply_message = @competition.success_message.to_s
              end

              @message_to_send = ""
              if @incoming_message.save!

                ## Check if there is a special message we need to send
                if @competition.send_special_message.nil? == false

                  if @competition.send_special_message == true
                    sms_count = IncomingMessage.find_all_by_sender_and_keyword(sender, keyword.to_s.strip.upcase).count

                    if @competition.special_message_incoming_count == sms_count

                      @message_to_send = @competition.special_message_content

                    else

                      @message_to_send = @incoming_message.reply_message

                    end

                  else

                    @message_to_send = @incoming_message.reply_message

                  end

                else

                  @message_to_send = @incoming_message.reply_message

                end

              end

              @send_response.msgdata = @message_to_send
              @send_response.sms_type = 2

              if @send_response.save!

                @incoming_message.reply_sent = true
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              else

                @incoming_message.reply_sent = false
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              end

            end

          else
            ### The competition close date has been reached so send closed message
            @incoming_message.matched_to_competition = true
            @incoming_message.matched_to_devotional = false
            @incoming_message.matched_to_quiz = false
            @incoming_message.competition_id = @competition.id
            @incoming_message.reply_message = "SMS entry for #{@competition.keyword} is not open yet. Please try again on the #{@competition.start_date.strftime("%d-%m-%Y")}. Thank you.[PRE]"

            if @incoming_message.save!

              @send_response.msgdata = @incoming_message.reply_message
              @send_response.sms_type = 2

              if @send_response.save!


                @incoming_message.reply_sent = true
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!

              else

                @incoming_message.reply_sent = false
                @incoming_message.reply_sent_date_time = Time.now
                @incoming_message.save!


              end

            end

          end

        else
          ### This competition is not active so send inactive competition message
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

            else

              @incoming_message.reply_sent = false
              @incoming_message.reply_sent_date_time = Time.now
              @incoming_message.save!


            end


          end


        end


      else

        #### The competition was not found so send error message
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

          else

            @incoming_message.reply_sent = false
            @incoming_message.reply_sent_date_time = Time.now
            @incoming_message.save!


          end


        end

      end

    end

  end

end