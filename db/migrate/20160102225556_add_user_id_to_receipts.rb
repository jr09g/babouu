class AddUserIdToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :user_id, :integer
    add_index :receipts, :user_id
  end
end
