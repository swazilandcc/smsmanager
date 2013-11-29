class QuizQuestionAnswer < ActiveRecord::Base
  attr_accessible :answer, :correct_answer, :letter, :quiz_question_id, :score
  belongs_to :quiz_question
end
