# frozen_string_literal: true

class AddEventLinkToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :event_link, :string
  end
end
