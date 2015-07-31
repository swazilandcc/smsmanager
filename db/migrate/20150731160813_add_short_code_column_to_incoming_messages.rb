class AddShortCodeColumnToIncomingMessages < ActiveRecord::Migration
  def change
    add_column :incoming_messages, :short_code, :string
  end
end
