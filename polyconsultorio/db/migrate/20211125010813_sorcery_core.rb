class SorceryCore < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :email,            null: false
      t.string :crypted_password
      t.string :salt

      t.timestamps                null: false
    end

    add_index :people, :email, unique: true
  end
end
