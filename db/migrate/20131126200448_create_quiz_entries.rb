class CreateQuizEntries < ActiveRecord::Migration
  def change
    create_table :quiz_entries do |t|
      t.integer :quiz_id
      t.string :cell_number
      t.boolean :completed
      t.integer :current_question
      t.integer :incoming_message_id

      t.timestamps
    end
  end
end
