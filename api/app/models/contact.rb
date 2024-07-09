class Contact < ApplicationRecord
  belongs_to :user

  validates :name, :registration_number, :phone, :address, :zip_code, :latitude, :longitude, presence: true
  validate :valid_registration_number
  validates :registration_number, uniqueness: { scope: :user_id, message: 'already exists for this user' }

  private

  def valid_registration_number
    errors.add(:registration_number, 'Registration number not valid') unless CPF.valid?(registration_number)
  end
end
