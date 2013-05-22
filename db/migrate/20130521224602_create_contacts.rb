class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :cell_number

      t.timestamps
    end
    add_index :contacts, :first_name
    add_index :contacts, :cell_number
  end
end
