class AddPriceToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :price, :float
  end
end
