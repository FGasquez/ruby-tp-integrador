class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.string :name
      t.string :surname
      t.string :professional
      t.string :phone
      t.string :notes
      t.date   :date
      
      t.timestamps
    end
  end
end