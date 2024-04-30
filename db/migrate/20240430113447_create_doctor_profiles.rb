class CreateDoctorProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :doctor_profiles do |t|

      t.timestamps
    end
  end
end
