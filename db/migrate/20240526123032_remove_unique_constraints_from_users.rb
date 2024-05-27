class RemoveUniqueConstraintsFromUsers < ActiveRecord::Migration[7.1]
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
    execute <<-SQL
      ALTER TABLE users
      DROP CONSTRAINT check_if_email_is_unique,
      DROP CONSTRAINT check_if_phone_number_is_unique;
    SQL
  end

  def down
    add_unique_constraints(:users, %i[email phone_number])
  end
end
