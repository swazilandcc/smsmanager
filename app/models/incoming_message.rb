class IncomingMessage < ActiveRecord::Base
  attr_accessible :competition_id, :devotional_id, :extra_text, :keyword, :matched_to_competition,
                  :matched_to_devotional, :option, :reply_message, :reply_sent, :reply_sent_date_time, :sender, :matched_to_quiz, :short_code
  has_many :quiz_entry_answers

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |incoming|
        csv << incoming.attributes.values_at(*column_names)
      end
    end
  end
end
