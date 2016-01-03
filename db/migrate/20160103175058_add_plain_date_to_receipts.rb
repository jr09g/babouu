class AddPlainDateToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :plain_date, :date
  end
end
