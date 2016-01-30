class AddExpenseReportStatusIdToExpenseReports < ActiveRecord::Migration
  def change
    add_column :expense_reports, :expense_report_status_id, :integer
    add_index :expense_reports, :expense_report_status_id
  end
end
