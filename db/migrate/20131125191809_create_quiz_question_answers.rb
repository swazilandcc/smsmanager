class CreateQuizQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :quiz_question_answers do |t|
      t.integer :quiz_question_id
      t.string :letter
      t.text :answer
      t.boolean :correct_answer

      t.timestamps
    end
    add_index :quiz_question_answers, :quiz_question_id
  end
end
