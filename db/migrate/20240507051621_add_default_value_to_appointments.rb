class AddDefaultValueToAppointments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :appointments, :duration_minutes, 15
  end
end
