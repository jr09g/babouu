class NewOne < ActiveRecord::Migration
  def change
  	drop_table :add_user_id_to_users_groups
  end
end
