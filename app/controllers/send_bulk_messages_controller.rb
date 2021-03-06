class SendBulkMessagesController < ApplicationController
  load_and_authorize_resource
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

  def send_bulk_out

    @message = ""

    begin

      @sms_number = IncomingMessage.all(:select => "sender, competition_id", :conditions => "competition_id = #{params[:competition_id]}", :group => "sender") rescue nil
      @send_list = []

      @sms_number.each do |x|
        @send_list << x.sender
      end

      if params[:message].nil? == false
        BulkOutWorker.perform_async(@send_list, params[:message], current_user.id)
      end

      @message = "Bulk SMS was dispatched for delivery successfully!"

    rescue

      @message = "There was an error sending Bulk Message, Please contact system administrator"

    end


    respond_to do |format|

      format.js { render js: "alert('#{@message}'); location.reload;"}

    end

  end

  # POST /send_bulk_messages
  # POST /send_bulk_messages.json
  def create
    @send_bulk_message = SendBulkMessage.new(params[:send_bulk_message])

    respond_to do |format|
      if @send_bulk_message.save
        BulkSendWorker.perform_async(@send_bulk_message.group_id, @send_bulk_message.message, current_user.id, @send_bulk_message.id)

        format.html { redirect_to send_bulk_messages_url, notice: 'Bulk Message successfully submitted for delivery!' }
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

  def getContacts

    group_id = params[:groupID]

    @contacts =  @contacts = Contact.all(:joins => "INNER JOIN contacts_groups ON contacts.id = contacts_groups.contact_id", :conditions => "contacts_groups.group_id = #{group_id}")

    respond_to do |format|
      format.json { render json: {:contacts => @contacts}}
    end

  end


end
