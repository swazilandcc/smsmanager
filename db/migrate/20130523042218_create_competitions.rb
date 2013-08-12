class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :keyword
      t.boolean :keyword_case_sensitive
      t.integer :user_id
      t.text :success_message
      t.text :closed_message
      t.boolean :active
      t.string :incorrect_option_message
      t.boolean :response_include_serial


      t.timestamps
    end
  end
end
