class AddSpecialMessageColumnsToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :send_special_message, :boolean
    add_column :competitions, :special_message_incoming_count, :integer
    add_column :competitions, :special_message_content, :text
  end
end
