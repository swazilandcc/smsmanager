class QuizQuestion < ActiveRecord::Base
  attr_accessible :question, :quiz_id, :quiz_question_answers_attributes
  belongs_to :quiz
  has_many :quiz_question_answers
  has_many :quiz_entry_answers

  accepts_nested_attributes_for :quiz_question_answers, :reject_if => :all_blank, :allow_destroy => true
end
