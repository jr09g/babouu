class AddReceiptIdToReceiptItems < ActiveRecord::Migration
  def change
    add_column :receipt_items, :receipt_id, :integer
    add_index :receipt_items, :receipt_id
  end
end