class CreateAddUserIdToUsersGroups < ActiveRecord::Migration
  def change
    create_table :add_user_id_to_users_groups do |t|
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :add_user_id_to_users_groups, :user_id
  end
end
