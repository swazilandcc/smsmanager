class Quiz < ActiveRecord::Base
  attr_accessible :correct_answer, :enabled, :incorrect_answer, :keyword, :next_on_incorrect, :welcome_message, :quiz_questions_attributes
  validates_uniqueness_of :keyword
  validates_presence_of :keyword, :correct_answer, :welcome_message, :incorrect_answer



  has_many :quiz_questions
  has_many :quiz_entries

  accepts_nested_attributes_for :quiz_questions, :reject_if => :all_blank, :allow_destroy => true

end
