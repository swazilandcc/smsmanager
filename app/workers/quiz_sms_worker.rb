class QuizSmsWorker
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

      @sms_quiz = Quiz.find_by_keyword(keyword.to_s.strip.upcase)

      if @sms_quiz.nil? == false

        @existing_session = QuizEntry.find_by_cell_number_and_completed_and_quiz_id(sender, false, @sms_quiz.id) rescue nil

        if @existing_session.nil? == true

          #prepare the welcome message
          @incoming_message.matched_to_competition = false
          @incoming_message.matched_to_devotional = false
          @incoming_message.matched_to_quiz = true
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

          # check if the submitted answer matches the available answers
          if QuizQuestionAnswer.find_all_by_quiz_question_id_and_letter(@existing_session.current_question, option.to_s.downcase).count == 1

            # the answer provided by the user is valid, check if this answer is the correct answer for the question
            if QuizQuestionAnswer.find_by_quiz_question_id_and_letter(@existing_session.current_question, option.to_s.downcase).correct_answer? == true
              # the answer provided by the user is correct, prepare the correct answer message and send

              @incoming_message.matched_to_competition = false
              @incoming_message.matched_to_devotional = false
              @incoming_message.matched_to_quiz = true
              @incoming_message.reply_message = @sms_quiz.correct_answer

              #@send_response.msgdata = @sms_quiz.quiz_questions.first(:order => 'id ASC').question rescue nil
              @send_response.msgdata = @sms_quiz.correct_answer
              @send_response.sms_type = 2

              if @incoming_message.save

                # record this entry
                @new_quiz_answer_entry = QuizEntryAnswer.new
                @new_quiz_answer_entry.quiz_entry_id = @existing_session.id
                @new_quiz_answer_entry.quiz_question_id = @existing_session.current_question
                @new_quiz_answer_entry.quiz_question_answer_id = QuizQuestionAnswer.find_by_quiz_question_id_and_letter(@existing_session.current_question, option.to_s.downcase).id

                if @new_quiz_answer_entry.save

                  if @send_response.save

                    # find the next question and send
                    @existing_entries = QuizEntryAnswer.find_all_by_quiz_entry_id(@existing_session.id).map {|q| q.quiz_question_id}.join ','
                    @next_question = QuizQuestion.first(:conditions => "quiz_id = #{@existing_session.quiz_id} AND id NOT IN (#{@existing_entries})", :order => 'id ASC').id rescue nil

                    if @next_question.nil? == false

                      # Send SMS Quiz and Answers

                      @send_response = SendSMS.new
                      @send_response.momt = "MT"
                      @send_response.sender = "7070"
                      @send_response.receiver = sender

                      #compose Question and Answers
                      q = QuizQuestion.find(@next_question)
                      @qNa = q.question.to_s
                      q.quiz_question_answers.each do |x|
                        @qNa += "\n#{x.letter}. #{x.answer}"
                      end

                      @send_response.msgdata = @qNa rescue nil
                      @send_response.sms_type = 2

                      if @send_response.save

                        @existing_session.current_question = @next_question
                        @existing_session.save

                      end

                    else

                      @existing_session.completed = true
                      @existing_session.save

                      # Send SMS Quiz and Answers
                      @send_response = SendSMS.new
                      @send_response.momt = "MT"
                      @send_response.sender = "7070"
                      @send_response.receiver = sender
                      @send_response.msgdata = "You have reached the end of this quiz. Thank you for participating."
                      @send_response.sms_type = 2
                      @send_response.save


                    end


                  end


                end


              end

            else

              # the answer provided by the user is incorrect, prepare the incorrect answer message and send

              @incoming_message.matched_to_competition = false
              @incoming_message.matched_to_devotional = false
              @incoming_message.matched_to_quiz = true
              @incoming_message.reply_message = @sms_quiz.incorrect_answer

              #@send_response.msgdata = @sms_quiz.quiz_questions.first(:order => 'id ASC').question rescue nil
              @send_response.msgdata = @sms_quiz.incorrect_answer
              @send_response.sms_type = 2

              if @incoming_message.save

                # record this entry
                @new_quiz_answer_entry = QuizEntryAnswer.new
                @new_quiz_answer_entry.quiz_entry_id = @existing_session.id
                @new_quiz_answer_entry.quiz_question_id = @existing_session.current_question
                @new_quiz_answer_entry.quiz_question_answer_id = QuizQuestionAnswer.find_by_quiz_question_id_and_letter(@existing_session.current_question, option.to_s.downcase).id

                if @new_quiz_answer_entry.save

                  if @send_response.save

                    # find the next question and send
                    @existing_entries = QuizEntryAnswer.find_all_by_quiz_entry_id(@existing_session.id).map {|q| q.quiz_question_id}.join ','
                    @next_question = QuizQuestion.first(:conditions => "quiz_id = #{@existing_session.quiz_id} AND id NOT IN (#{@existing_entries})", :order => 'id ASC').id rescue nil

                    if @next_question.nil? == false

                      # Send SMS Quiz and Answers

                      @send_response = SendSMS.new
                      @send_response.momt = "MT"
                      @send_response.sender = "7070"
                      @send_response.receiver = sender

                      #compose Question and Answers
                      q = QuizQuestion.find(@next_question)
                      @qNa = q.question.to_s
                      q.quiz_question_answers.each do |x|
                        @qNa += "\n#{x.letter}. #{x.answer}"
                      end

                      @send_response.msgdata = @qNa rescue nil
                      @send_response.sms_type = 2

                      if @send_response.save

                        @existing_session.current_question = @next_question
                        @existing_session.save

                      end

                    else

                      @existing_session.completed = true
                      @existing_session.save

                      # Send SMS Quiz and Answers
                      @send_response = SendSMS.new
                      @send_response.momt = "MT"
                      @send_response.sender = "7070"
                      @send_response.receiver = sender
                      @send_response.msgdata = "You have reached the end of this quiz. Thank you for participating."
                      @send_response.sms_type = 2
                      @send_response.save


                    end


                  end


                end

              end

            end


          else

            # the answer provided by the user is invalid
            # send the invalid answer message
            @incoming_message.matched_to_competition = false
            @incoming_message.matched_to_devotional = false
            @incoming_message.matched_to_quiz = true
            @incoming_message.reply_message = 'The answer you have sent is invalid, please make sure you send one of the possible answer letters you received contained within the question. Thank you.'

            #@send_response.msgdata = @sms_quiz.quiz_questions.first(:order => 'id ASC').question rescue nil
            @send_response.msgdata = 'The answer you have sent is invalid, please make sure you send one of the possible answer letters you received contained within the question. Thank you.'
            @send_response.sms_type = 2

            if @incoming_message.save
              @send_response.save
            end

          end

        end

      end

    end

  end

end
