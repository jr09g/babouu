class AddCompanyNameToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :company_name, :string
  end
end
