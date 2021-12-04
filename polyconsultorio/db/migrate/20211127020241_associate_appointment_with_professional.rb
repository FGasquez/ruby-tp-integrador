class AssociateAppointmentWithProfessional < ActiveRecord::Migration[6.1]
  def change
    add_index :appointments, [:date, :professional_id], unique: true 
  end
end
