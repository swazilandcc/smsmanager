class AddMatchedToQuizColumnToIncomingMessage < ActiveRecord::Migration
  def change
    add_column :incoming_messages, :matched_to_quiz, :boolean
  end
end
