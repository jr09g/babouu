class AddBusinessIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :business_id, :integer
    add_index :groups, :business_id
  end
end
