class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :keyword
      t.text :welcome_message
      t.text :correct_answer
      t.text :incorrect_answer
      t.boolean :enabled
      t.boolean :next_on_incorrect

      t.timestamps
    end
  end
end
