# frozen_string_literal: true

class AddEventIdToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :event_id, :string
  end
end
