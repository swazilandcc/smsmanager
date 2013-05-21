class IncomingMessage < ActiveRecord::Base
  attr_accessible :competition_id, :devotional_id, :extra_text, :keyword, :matched_to_competition, :matched_to_devotional, :option, :reply_message, :reply_sent, :reply_sent_date_time, :sender
end
