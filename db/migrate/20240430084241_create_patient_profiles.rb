# frozen_string_literal: true

class CreatePatientProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :patient_profiles do |t|
      t.integer :blood_group, null: false
      t.integer :height_cm, null: false
      t.integer :weight_kg, null: false
      t.text :medical_history
      t.string :nid_number, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps

      t.unique_constraint [:nid_number], name: 'check_if_nid_number_is_unique'
      t.unique_constraint [:user_id], name: 'check_if_profile_owner_user_id_is_unique'
    end
  end
end
