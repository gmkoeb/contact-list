class ContactsController < ApplicationController
  before_action :authenticate_user
  before_action :check_user, only: %w[update destroy show]

  def index
    render status: :ok, json: { contacts: @current_user.contacts }
  end

  def show
    render status: :ok, json: { contact: }
  end

  def create
    contact = @current_user.contacts.build(contact_params)
    if contact.save
      render status: :ok, json: { message: 'Contact created with success!' }
    else
      render status: :unprocessable_content, json: { message: contact.errors.full_messages }
    end
  end

  def update
    if contact.update(contact_params)
      render status: :ok, json: { message: 'Contact updated with success.' }
    else
      render status: :unprocessable_content, json: { message: contact.errors.full_messages }
    end
  end

  def destroy
    contact.delete
    render status: :ok, json: { message: 'Contact deleted with success.' }
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :registration_number, :phone, :address,
                                    :zip_code, :latitude, :longitude)
  end

  def contact
    Contact.find(params[:id])
  end

  def check_user
    render status: :unauthorized, json: { message: 'Permission denied.' } if contact.user != @current_user
  end
end
