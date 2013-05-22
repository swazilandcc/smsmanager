class CreateBulkMessageTemplates < ActiveRecord::Migration
  def change
    create_table :bulk_message_templates do |t|
      t.string :name
      t.text :message

      t.timestamps
    end
  end
end
