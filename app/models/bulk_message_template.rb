class BulkMessageTemplate < ActiveRecord::Base
  attr_accessible :message, :name
  validates_presence_of :name, :message
  validates_length_of :message, :maximum => 160
end
