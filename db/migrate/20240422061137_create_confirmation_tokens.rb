# frozen_string_literal: true

class CreateConfirmationTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :confirmation_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token

      t.timestamps
    end

    add_index :confirmation_tokens, :token, unique: true
  end
end
