class SendBulkMessage < ActiveRecord::Base
  attr_accessible :group_id, :message, :status, :user_id
  belongs_to :group
  belongs_to :user

  validates_length_of :message, :maximum => 160

  validates_presence_of :group_id
  validates_presence_of :message

  def group_name
    return self.group.name rescue nil
  end

end
