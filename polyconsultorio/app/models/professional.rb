class Professional < ApplicationRecord
    has_many :appointments, dependent: :destroy

    validates :name, uniqueness: { scope: :surname, message: "Professional already exists" }
end
