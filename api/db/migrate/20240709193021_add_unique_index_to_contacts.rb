class AddUniqueIndexToContacts < ActiveRecord::Migration[7.1]
  def change
    add_index :contacts, [:user_id, :registration_number], unique: true
  end
end
