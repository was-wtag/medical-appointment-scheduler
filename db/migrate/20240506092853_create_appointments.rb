class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.datetime :scheduled_time, null: false
      t.integer :duration_minutes, null: false
      t.integer :status, null: false, default: 0
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.references :doctor, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
