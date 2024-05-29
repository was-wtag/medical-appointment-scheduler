class AddNotNullConstraintsAndRemoveDefaulValuesFromUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
    change_column_null :users, :gender, false
    change_column_null :users, :date_of_birth, false
    change_column_null :users, :role, false
    change_column_null :users, :email, false
    change_column_null :users, :phone_number, false
    change_column_null :users, :password_digest, false

    change_column_default :users, :role, from: 2, to: nil
    change_column_default :users, :gender, from: 0, to: nil
  end
end
