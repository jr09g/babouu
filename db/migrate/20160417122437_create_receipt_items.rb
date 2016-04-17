class CreateReceiptItems < ActiveRecord::Migration
  def change
    create_table :receipt_items do |t|
      t.string :description
      t.float :price
      t.string :category

      t.timestamps null: false
    end
  end
end