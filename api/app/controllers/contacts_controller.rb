class ContactsController < ApplicationController
  before_action :authenticate_user

  def index
    render status: :ok, json: { contacts: @current_user.contacts }
  end

  def create
    contact_params = params.require(:contact).permit(:name, :registration_number, :phone, :address,
                                                     :zip_code, :latitude, :longitude)
    contact = @current_user.contacts.build(contact_params)
    if contact.save
      render status: :ok, json: { message: 'Contact created with success!' }
    else
      render status: :unprocessable_content, json: { message: contact.errors.full_messages }
    end
  end
  
  def destroy
    contact = Contact.find(params[:id])

    if contact.user == @current_user
      contact.delete
      render status: :ok, json: { message: 'Contact deleted with success.' }
    else
      render status: :unauthorized, json: { message: "Permission denied." }
    end
  end
end
