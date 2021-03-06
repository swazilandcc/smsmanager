require 'sms_quiz_worker'
require 'incoming_sms_worker'
require 'daily_verse_worker'

class IncomingMessagesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:receive]


  # GET /incoming_messages
  # GET /incoming_messages.json
  def index
    @incoming_messages = IncomingMessage.order("created_at DESC").page(params[:page]).per_page(30)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @incoming_messages }
      format.xls
    end

  end

  def genExcel
    @incoming_messages = IncomingMessage.order("created_at DESC").all

    respond_to do |format|
      format.xls
    end

  end

  # GET /incoming_messages/1
  # GET /incoming_messages/1.json
  def show
    @incoming_message = IncomingMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @incoming_message }
    end

  end

  # Process Incoming SMS Message
  def receive

    sender = params[:sender] rescue nil
    keyword = params[:keyword] rescue nil
    option = params[:option] rescue nil
    extra_text = params[:extra_text] rescue nil
    short_code = params[:short_code] rescue nil

    if keyword.downcase == "vod"

      DailyVerseWorker.perform_async(sender, keyword, option, extra_text, 'Your message has been successfully received. Thank you!', short_code)

    else

      @check_if_quiz = Quiz.find_by_keyword(keyword.to_s.strip.upcase)
      @check_if_competition = Competition.find_by_keyword(keyword.to_s.strip.upcase)

      if @check_if_quiz.nil? == false && @check_if_competition.nil? == true

        SmsQuizWorker.perform_async(sender, keyword, option, extra_text, 'Your quiz response has been successfully received. Thank you!', short_code)

     elsif @check_if_competition.nil? == false && @check_if_quiz.nil? == true

        IncomingSmsWorker.perform_async(sender, keyword, option, extra_text, 'Your message has been successfully received. Thank you!', short_code)

     else

       IncomingSmsWorker.perform_async(sender, keyword, option, extra_text, 'Your message has been received with thanks and will be considered. Thank you for supporting our TV and Radio Ministry Programs. God bless you. Mt 28:19-20', short_code)

      end

    end

    render text: "OK"

  end

  # GET /incoming_messages/new
  # GET /incoming_messages/new.json
  def new
    @incoming_message = IncomingMessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @incoming_message }
    end
  end

  # GET /incoming_messages/1/edit
  def edit
    @incoming_message = IncomingMessage.find(params[:id])
  end

  # POST /incoming_messages
  # POST /incoming_messages.json
  def create
    @incoming_message = IncomingMessage.new(params[:incoming_message])

    respond_to do |format|
      if @incoming_message.save
        format.html { redirect_to @incoming_message, notice: 'Incoming message was successfully created.' }
        format.json { render json: @incoming_message, status: :created, location: @incoming_message }
      else
        format.html { render action: "new" }
        format.json { render json: @incoming_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /incoming_messages/1
  # PUT /incoming_messages/1.json
  def update
    @incoming_message = IncomingMessage.find(params[:id])

    respond_to do |format|
      if @incoming_message.update_attributes(params[:incoming_message])
        format.html { redirect_to @incoming_message, notice: 'Incoming message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @incoming_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incoming_messages/1
  # DELETE /incoming_messages/1.json
  def destroy
    @incoming_message = IncomingMessage.find(params[:id])
    @incoming_message.destroy

    respond_to do |format|
      format.html { redirect_to incoming_messages_url }
      format.json { head :no_content }
    end
  end
end
