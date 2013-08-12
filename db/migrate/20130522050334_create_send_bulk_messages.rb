class CreateSendBulkMessages < ActiveRecord::Migration
  def change
    create_table :send_bulk_messages do |t|
      t.integer :group_id
      t.text :message
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
