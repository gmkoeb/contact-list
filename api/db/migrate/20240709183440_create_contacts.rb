class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :registration_number
      t.string :phone
      t.string :address
      t.string :zip_code
      t.integer :latitude
      t.integer :longitude

      t.timestamps
    end
  end
end
