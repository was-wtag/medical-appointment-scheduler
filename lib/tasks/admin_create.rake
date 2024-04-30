# frozen_string_literal: true

namespace :admin do
  desc 'Create an admin user'
  task create: :environment do
    admin_info = {
      first_name: ENV.fetch('ADMIN_FIRST_NAME', nil),
      last_name: ENV.fetch('ADMIN_LAST_NAME', nil),
      gender: User.genders[:not_specified],
      role: User.roles[:admin],
      date_of_birth: ENV.fetch('ADMIN_DOB', nil),
      email: ENV.fetch('ADMIN_EMAIL', nil),
      phone_number: ENV.fetch('ADMIN_PHONE_NO', nil),
      status: User.statuses[:active],
      password: ENV.fetch('ADMIN_PASSWORD', nil),
      password_confirmation: ENV.fetch('ADMIN_PASSWORD', nil)
    }

    admin = User.new(**admin_info)

    begin
      admin.save!
    rescue ActiveRecord::RecordInvalid => e
      warn "Task Failed: #{e.message} due to the following errors:\n#{admin.errors.full_messages.join("\n")}"
    end
  end
end
