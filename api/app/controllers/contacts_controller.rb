class ContactsController < ApplicationController
  before_action :authenticate_user
  before_action :check_user, only: %w[update destroy show]

  def index
    render status: :ok, json: { contacts: @current_user.contacts.order(:name) }
  end

  def show
    if contact
      render status: :ok, json: { contact: }
    else
      render status: :not_found, json: { message: 'Contact not found' }
    end
  end

  def create
    contact = @current_user.contacts.build(contact_params)
    if contact.save
      render status: :created, json: { message: 'Contact created with success!' }
    else
      render status: :unprocessable_content, json: { message: contact.errors.full_messages }
    end
  end

  def update
    @contact = contact
    if @contact.update(contact_params)
      render status: :ok, json: { message: 'Contact updated with success.' }
    else
      render status: :unprocessable_content, json: { message: @contact.errors.full_messages }
    end
  end

  def destroy
    contact.delete
    render status: :ok, json: { message: 'Contact deleted with success.' }
  end

  def address_helper
    uf = params[:uf]
    city = URI.encode_uri_component(params[:city])
    address = URI.encode_uri_component(params[:address])

    response = Faraday.get("https://viacep.com.br/ws/#{uf}/#{city}/#{address}/json/")

    if response.status == 200
      render status: :ok, json: { suggestions: JSON.parse(response.body) }
    else
      render status: :unprocessable_content, json: { message: 'Invalid address' }
    end
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
