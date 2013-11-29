class AddScoreColumnToQuizQuestionAnswer < ActiveRecord::Migration
  def change
    add_column :quiz_question_answers, :score, :integer
  end
end
