class CreateSmsLogs < ActiveRecord::Migration
  def change
    create_table :sms_logs do |t|
      t.string :cell_number
      t.string :message
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
