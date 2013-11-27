class QuizEntryAnswer < ActiveRecord::Base
  attr_accessible :quiz_entry_id, :quiz_question_answer_id, :quiz_question_id
  belongs_to :quiz_entry
  belongs_to :quiz_question
  belongs_to :quiz_question_answer
end
