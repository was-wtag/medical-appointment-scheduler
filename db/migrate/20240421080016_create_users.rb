class CreateUsers < ActiveRecord::Migration[7.1]
  def add_unique_constraints(table_name, columns)
    columns.each do |column|
      execute <<-SQL
        ALTER TABLE #{table_name}
        ADD CONSTRAINT check_if_#{column}_is_unique
        UNIQUE (#{column});
      SQL
    end
  end

  def up
    create_table :users do |t|
      t.string :first_name, limit: 128
      t.string :last_name, limit: 128
      t.integer :gender, default: 0
      t.date :date_of_birth
      t.integer :role, default: 2
      t.string :email
      t.string :phone_number
      t.string :password_digest
      t.datetime :last_login_at
      t.timestamps
    end

    add_unique_constraints(:users, %i[email phone_number])
  end

  def down
    execute <<-SQL
      ALTER TABLE users
      DROP CONSTRAINT check_if_email_is_unique,
      DROP CONSTRAINT check_if_phone_number_is_unique;
    SQL

    drop_table :users
  end
end
