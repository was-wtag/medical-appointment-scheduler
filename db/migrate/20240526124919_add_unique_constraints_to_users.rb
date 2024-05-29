class AddUniqueConstraintsToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      t.unique_constraint :email
      t.unique_constraint :phone_number
    end
  end
end
