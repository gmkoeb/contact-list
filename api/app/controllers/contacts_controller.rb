class ContactsController < ApplicationController
  before_action :authenticate_user

  def index; end

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
end
