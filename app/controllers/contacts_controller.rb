class ContactsController < ApplicationController
  load_and_authorize_resource
  # GET /contacts
  # GET /contacts.json
  def index
    @q = Contact.search(params[:q])
    @contacts = @q.result.order("first_name").page(params[:page]).per_page(30)
    #@contacts = Contact.order("first_name").page(params[:page]).per_page(30)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
    end
  end

  def genExcel
    @contacts = Contact.order("first_name DESC").all

    respond_to do |format|
      format.xls
    end

  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        if params[:format].nil? == false

          format.js { render js: "$('#importContactInfo').html('<h3>Contact Imported Successfully!<h3>'); $('#saved').val('true');" }

        else
          format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
          format.json { render json: @contact, status: :created, location: @contact }
        end
      else
        if params[:format].nil? == false

          format.js { render js: "alert('Unable to import contact: #{@contact.errors}')"}

        else
          format.html { render action: "new" }
          format.json { render json: @contact.errors, status: :unprocessable_entity }
        end

      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end
end
