class ConfirmationToken < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
