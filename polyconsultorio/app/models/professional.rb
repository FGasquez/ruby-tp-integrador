class Professional < ApplicationRecord
    has_many :appointments, dependent: :destroy

    validates :name, uniqueness: { scope: :surname, message: "Professional already exists" }
    validates :name, :surname, presence: true 

    def full_name
        "#{name} #{surname}"
    end
end
