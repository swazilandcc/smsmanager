class CreateCompetitionOptions < ActiveRecord::Migration
  def change
    create_table :competition_options do |t|
      t.integer :competition_id
      t.integer :option_number
      t.string :option_name

      t.timestamps
    end
  end
end
