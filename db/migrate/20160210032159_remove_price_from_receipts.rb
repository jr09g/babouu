class RemovePriceFromReceipts < ActiveRecord::Migration
  def change
    remove_column :receipts, :price, :integer
  end
end
