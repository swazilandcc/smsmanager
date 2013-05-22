class SendBulkMessagesController < ApplicationController
  # GET /send_bulk_messages
  # GET /send_bulk_messages.json
  def index
    @send_bulk_messages = SendBulkMessage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @send_bulk_messages }
    end
  end

  # GET /send_bulk_messages/1
  # GET /send_bulk_messages/1.json
  def show
    @send_bulk_message = SendBulkMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @send_bulk_message }
    end
  end

  # GET /send_bulk_messages/new
  # GET /send_bulk_messages/new.json
  def new
    @send_bulk_message = SendBulkMessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @send_bulk_message }
    end
  end

  # GET /send_bulk_messages/1/edit
  def edit
    @send_bulk_message = SendBulkMessage.find(params[:id])
  end

  # POST /send_bulk_messages
  # POST /send_bulk_messages.json
  def create
    @send_bulk_message = SendBulkMessage.new(params[:send_bulk_message])

    respond_to do |format|
      if @send_bulk_message.save
        format.html { redirect_to send_bulk_message_path, notice: 'Bulk Message successfully submitted for delivery!' }
        format.json { render json: @send_bulk_message, status: :created, location: @send_bulk_message }
      else
        format.html { render action: "new" }
        format.json { render json: @send_bulk_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /send_bulk_messages/1
  # PUT /send_bulk_messages/1.json
  def update
    @send_bulk_message = SendBulkMessage.find(params[:id])

    respond_to do |format|
      if @send_bulk_message.update_attributes(params[:send_bulk_message])
        format.html { redirect_to @send_bulk_message, notice: 'Send bulk message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @send_bulk_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /send_bulk_messages/1
  # DELETE /send_bulk_messages/1.json
  def destroy
    @send_bulk_message = SendBulkMessage.find(params[:id])
    @send_bulk_message.destroy

    respond_to do |format|
      format.html { redirect_to send_bulk_messages_url }
      format.json { head :no_content }
    end
  end
end
