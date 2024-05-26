# frozen_string_literal: true

class ModifyUniqueConstraintsInUsers < ActiveRecord::Migration[7.1]
  def change
    execute <<-SQL
      ALTER TABLE users
      DROP CONSTRAINT check_if_email_is_unique,
      DROP CONSTRAINT check_if_phone_number_is_unique;
    SQL
  end
end
