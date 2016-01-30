class AddGroupIdToUsersGroups < ActiveRecord::Migration
  def change
    add_column :users_groups, :group_id, :integer
    add_index :users_groups, :group_id
  end
end
