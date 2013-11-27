class CreateQuizEntryAnswers < ActiveRecord::Migration
  def change
    create_table :quiz_entry_answers do |t|
      t.integer :quiz_entry_id
      t.integer :quiz_question_id
      t.integer :quiz_question_answer_id

      t.timestamps
    end
  end
end
