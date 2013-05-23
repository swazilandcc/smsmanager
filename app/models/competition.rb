class Competition < ActiveRecord::Base
  attr_accessible :description, :end_date, :incorrect_option_message, :keyword, :keyword_case_sensitive, :name, :response_include_serial, :start_date, :success_message, :closed_message, :user_id, :active, :competition_options_attributes
  has_many :competition_options
  accepts_nested_attributes_for :competition_options, :allow_destroy => true, :reject_if => :all_blank

  validates_presence_of :name, :description, :keyword, :start_date, :end_date, :success_message, :closed_message
  validates_uniqueness_of :name, :keyword, :start_date

  belongs_to :user

end
