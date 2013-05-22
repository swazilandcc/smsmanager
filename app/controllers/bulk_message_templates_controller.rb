class BulkMessageTemplatesController < ApplicationController
  # GET /bulk_message_templates
  # GET /bulk_message_templates.json
  def index
    @bulk_message_templates = BulkMessageTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bulk_message_templates }
    end
  end

  # GET /bulk_message_templates/1
  # GET /bulk_message_templates/1.json
  def show
    @bulk_message_template = BulkMessageTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bulk_message_template }
    end
  end

  # GET /bulk_message_templates/new
  # GET /bulk_message_templates/new.json
  def new
    @bulk_message_template = BulkMessageTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bulk_message_template }
    end
  end

  # GET /bulk_message_templates/1/edit
  def edit
    @bulk_message_template = BulkMessageTemplate.find(params[:id])
  end

  # POST /bulk_message_templates
  # POST /bulk_message_templates.json
  def create
    @bulk_message_template = BulkMessageTemplate.new(params[:bulk_message_template])

    respond_to do |format|
      if @bulk_message_template.save
        format.html { redirect_to @bulk_message_template, notice: 'Bulk message template was successfully created.' }
        format.json { render json: @bulk_message_template, status: :created, location: @bulk_message_template }
      else
        format.html { render action: "new" }
        format.json { render json: @bulk_message_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bulk_message_templates/1
  # PUT /bulk_message_templates/1.json
  def update
    @bulk_message_template = BulkMessageTemplate.find(params[:id])

    respond_to do |format|
      if @bulk_message_template.update_attributes(params[:bulk_message_template])
        format.html { redirect_to @bulk_message_template, notice: 'Bulk message template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bulk_message_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_message_templates/1
  # DELETE /bulk_message_templates/1.json
  def destroy
    @bulk_message_template = BulkMessageTemplate.find(params[:id])
    @bulk_message_template.destroy

    respond_to do |format|
      format.html { redirect_to bulk_message_templates_url }
      format.json { head :no_content }
    end
  end
end
