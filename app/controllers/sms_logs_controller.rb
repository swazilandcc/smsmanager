class SmsLogsController < ApplicationController
  # GET /sms_logs
  # GET /sms_logs.json
  def index
    @sms_logs = SmsLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sms_logs }
    end
  end

  # GET /sms_logs/1
  # GET /sms_logs/1.json
  def show
    @sms_log = SmsLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sms_log }
    end
  end

  # GET /sms_logs/new
  # GET /sms_logs/new.json
  def new
    @sms_log = SmsLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sms_log }
    end
  end

  # GET /sms_logs/1/edit
  def edit
    @sms_log = SmsLog.find(params[:id])
  end

  # POST /sms_logs
  # POST /sms_logs.json
  def create
    @sms_log = SmsLog.new(params[:sms_log])

    respond_to do |format|
      if @sms_log.save
        format.html { redirect_to @sms_log, notice: 'Sms log was successfully created.' }
        format.json { render json: @sms_log, status: :created, location: @sms_log }
      else
        format.html { render action: "new" }
        format.json { render json: @sms_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sms_logs/1
  # PUT /sms_logs/1.json
  def update
    @sms_log = SmsLog.find(params[:id])

    respond_to do |format|
      if @sms_log.update_attributes(params[:sms_log])
        format.html { redirect_to @sms_log, notice: 'Sms log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sms_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sms_logs/1
  # DELETE /sms_logs/1.json
  def destroy
    @sms_log = SmsLog.find(params[:id])
    @sms_log.destroy

    respond_to do |format|
      format.html { redirect_to sms_logs_url }
      format.json { head :no_content }
    end
  end
end
