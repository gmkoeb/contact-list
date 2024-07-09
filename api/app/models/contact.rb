class Contact < ApplicationRecord
  belongs_to :user

  validates :name, :registration_number, :phone, :address, :zip_code, :latitude, :longitude, presence: true
  validate :valid_registration_number
  validate :unique_registration_number_per_user

  private

  def valid_registration_number
    errors.add(:registration_number, 'Registration number not valid') unless CPF.valid?(registration_number)
  end

  def unique_registration_number_per_user
    return unless user.contacts.where(registration_number:).any?

    errors.add(:registration_number, 'Registration number already registered for this user')
  end
end
