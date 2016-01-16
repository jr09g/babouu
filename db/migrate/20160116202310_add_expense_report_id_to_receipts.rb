class AddExpenseReportIdToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :expense_report_id, :integer
    add_index :receipts, :expense_report_id
  end
end
