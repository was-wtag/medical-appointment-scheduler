# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_506_092_853) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'appointments', force: :cascade do |t|
    t.datetime 'scheduled_time', null: false
    t.integer 'duration_minutes', null: false
    t.integer 'status', default: 0, null: false
    t.bigint 'patient_id', null: false
    t.bigint 'doctor_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['doctor_id'], name: 'index_appointments_on_doctor_id'
    t.index ['patient_id'], name: 'index_appointments_on_patient_id'
  end

  create_table 'doctor_profiles', force: :cascade do |t|
    t.integer 'specialty', null: false
    t.text 'chamber_address', null: false
    t.string 'registration_number', null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_doctor_profiles_on_user_id'
    t.unique_constraint ['registration_number'], name: 'check_if_registration_number_is_unique'
    t.unique_constraint ['user_id'], name: 'check_if_profile_owner_doctor_id_is_unique'
  end

  create_table 'patient_profiles', force: :cascade do |t|
    t.integer 'blood_group', null: false
    t.integer 'height_cm', null: false
    t.integer 'weight_kg', null: false
    t.text 'medical_history'
    t.string 'nid_number', null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_patient_profiles_on_user_id'
    t.unique_constraint ['nid_number'], name: 'check_if_nid_number_is_unique'
    t.unique_constraint ['user_id'], name: 'check_if_profile_owner_user_id_is_unique'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name', limit: 128, null: false
    t.string 'last_name', limit: 128, null: false
    t.integer 'gender', null: false
    t.date 'date_of_birth', null: false
    t.integer 'role', null: false
    t.string 'email', null: false
    t.string 'phone_number', null: false
    t.string 'password_digest', null: false
    t.datetime 'last_login_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'status', default: 0

    t.unique_constraint ['email'], name: 'check_if_email_is_unique'
    t.unique_constraint ['phone_number'], name: 'check_if_phone_number_is_unique'
  end

  add_foreign_key 'appointments', 'users', column: 'doctor_id'
  add_foreign_key 'appointments', 'users', column: 'patient_id'
  add_foreign_key 'doctor_profiles', 'users'
  add_foreign_key 'patient_profiles', 'users'
end
