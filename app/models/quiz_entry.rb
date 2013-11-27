class QuizEntry < ActiveRecord::Base
  attr_accessible :cell_number, :completed, :current_question, :incoming_message_id, :quiz_id

  belongs_to :quiz
  belongs_to :incoming_message

  has_many :quiz_entry_answers

end
