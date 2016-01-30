class CreateUsersGroups < ActiveRecord::Migration
  def change
    create_table :users_groups do |t|

      t.timestamps null: false
    end
  end
end
