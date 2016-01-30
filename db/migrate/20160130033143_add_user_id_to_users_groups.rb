class AddUserIdToUsersGroups < ActiveRecord::Migration
  def change
    add_column :users_groups, :user_id, :integer
    add_index :users_groups, :user_id
  end
end
