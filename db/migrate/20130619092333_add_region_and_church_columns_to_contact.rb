class AddRegionAndChurchColumnsToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :region_id, :integer
    add_column :contacts, :church, :string
  end
end
