class AddCompanyIdToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :company_id, :integer
    add_index :receipts, :company_id
  end
end
