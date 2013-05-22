class SmsLog < ActiveRecord::Base
  attr_accessible :cell_number, :message, :status, :user_id
  belongs_to :user
end
