# frozen_string_literal: true

class CreateDoctorProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :doctor_profiles do |t|
      t.integer :specialty, null: false
      t.text :chamber_address, null: false
      t.string :registration_number, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps

      t.unique_constraint [:registration_number], name: 'check_if_registration_number_is_unique'
      t.unique_constraint [:user_id], name: 'check_if_profile_owner_doctor_id_is_unique'
    end
  end
end
