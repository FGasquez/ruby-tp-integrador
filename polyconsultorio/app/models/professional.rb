class Professional < ApplicationRecord
    has_many :appointments, dependent: :destroy

    validates :name, uniqueness: { scope: :surname, message: "Professional already exists" }, :length => { :minimum => 3 }
    validates :name, :surname, presence: true, :length => { :minimum => 3 }

    def full_name
        "#{name} #{surname}"
    end
end
