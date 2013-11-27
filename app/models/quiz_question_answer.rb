class QuizQuestionAnswer < ActiveRecord::Base
  attr_accessible :answer, :correct_answer, :letter, :quiz_question_id
  belongs_to :quiz_question
end
