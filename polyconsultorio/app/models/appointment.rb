class Appointment < ApplicationRecord
    belongs_to :professional
    # date must be unique and in the future and show message
    validates :date, uniqueness: { scope: :professional_id  } , presence: true
    validates :name, presence: true
    validates :surname, presence: true
    validates :phone,:presence => true,
                 :numericality => true,
                 :length => { :minimum => 7, :maximum => 15 }
end
