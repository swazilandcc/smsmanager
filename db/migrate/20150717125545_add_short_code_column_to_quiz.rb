class AddShortCodeColumnToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :short_code, :string
  end
end
