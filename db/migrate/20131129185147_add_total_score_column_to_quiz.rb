class AddTotalScoreColumnToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :total_score, :integer
  end
end
