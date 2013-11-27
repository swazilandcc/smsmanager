class IncomingSmsWorker
  require 'net/http'
  include Sidekiq::Worker

  def perform(sender, keyword, option, extra_text, message_to_send)

    @check_if_quiz = Quiz.where(:keyword => keyword.to_s.strip.upcase).first rescue nil

    if @check_if_quiz.nil? == false

      quiz(sender, keyword, option, extra_text, message_to_send)

    else

      normal_incoming(sender, keyword, option, extra_text, message_to_send)

    end

  end

  def normal_incoming(sender, keyword, option, extra_text, message_to_send)

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

              @send_response.msgdata = @competition.success_message.to_s + @rndString.to_s
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


              @send_response.msgdata = @competition.success_message.to_s + @rndString.to_s
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

  def quiz(sender, keyword, option, extra_text, message_to_send)

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

      @sms_quiz = Quiz.where(:keyword => keyword.to_s.strip.upcase).first

      if @sms_quiz.nil? == false

        @existing_session = QuizEntry.find_by_cell_number_and_completed_and_quiz_id(sender, false, @sms_quiz.id) rescue nil

        if @existing_session.nil? == true


          #prepare the welcome message
          @incoming_message.matched_to_competition = false
          @incoming_message.matched_to_devotional = false
          @incoming_message.matched_to_quiz = true
          @incoming_message.competition_id = 0
          @incoming_message.reply_message = @sms_quiz.welcome_message rescue nil

          #@send_response.msgdata = @sms_quiz.quiz_questions.first(:order => 'id ASC').question rescue nil
          @send_response.msgdata = @sms_quiz.welcome_message rescue nil
          @send_response.sms_type = 2

          if @incoming_message.save!

            if @send_response.save!

              @incoming_message.reply_sent = true
              @incoming_message.reply_sent_date_time = Time.now
              @incoming_message.save!

              # Send SMS Quiz and Answers

              @send_response = SendSMS.new
              @send_response.momt = "MT"
              @send_response.sender = "7070"
              @send_response.receiver = sender

              #compose Question and Answers
              q = @sms_quiz.quiz_questions.first(:order => 'id ASC')
              @qNa = q.question.to_s
              q.quiz_question_answers.each do |x|
                @qNa += "\n#{x.letter}. #{x.answer}"
              end

              @send_response.msgdata = @qNa rescue nil
              @send_response.sms_type = 2

              if @send_response.save
                @new_session = QuizEntry.new
                @new_session.cell_number = sender
                @new_session.completed = false
                @new_session.quiz_id = @sms_quiz.id

                ## Get Questions from Quiz in Ascending Order 1...n
                @new_session.current_question = @sms_quiz.quiz_questions.first(:order => 'id ASC').id rescue nil
                @new_session.incoming_message_id = @incoming_message.id
                @new_session.save!
              end

            end


          end



        else

         # there is an existing session for this sender, process answer for current question



        end

      end

    end

  end

end
