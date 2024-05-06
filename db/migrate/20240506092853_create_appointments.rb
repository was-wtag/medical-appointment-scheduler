class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.datetime :scheduled_time
      t.integer :duration_minutes
      t.integer :status
      t.references :patient_user, null: false, foreign_key: true
      t.references :doctor_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
