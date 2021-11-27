class Appointment < ApplicationRecord
    # date must be unique and in the future and show message
    validates :date, uniqueness: { scope: :professional_id  } , presence: true
end
