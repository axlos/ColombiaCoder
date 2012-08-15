class ContactsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /contacts
  # GET /contacts.json
  # Solo administrador
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    # current_user.contact
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = current_user.contact
    if @contact.update_attributes(params[:contact])
      redirect_to admin_jobs_path, notice: 'Informacion de contacto actualizada satisfactoriamente.'
    else
      render action: "edit"
    end
  end
  
end
