class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.string :receipt_desc
      t.integer :price

      t.timestamps null: false
    end
  end
end
