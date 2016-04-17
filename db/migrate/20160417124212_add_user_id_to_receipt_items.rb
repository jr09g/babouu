class AddUserIdToReceiptItems < ActiveRecord::Migration
  def change
    add_column :receipt_items, :user_id, :integer
    add_index :receipt_items, :user_id
  end
end