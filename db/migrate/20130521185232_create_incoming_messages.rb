class CreateIncomingMessages < ActiveRecord::Migration
  def change
    create_table :incoming_messages do |t|
      t.string :sender
      t.string :keyword
      t.string :option
      t.string :extra_text
      t.boolean :reply_sent
      t.datetime :reply_sent_date_time
      t.string :reply_message
      t.boolean :matched_to_competition
      t.boolean :matched_to_devotional
      t.integer :devotional_id
      t.integer :competition_id

      t.timestamps
    end
  end
end
