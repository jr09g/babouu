class RemoveExpenseReportStatusIdFromExpenseReports < ActiveRecord::Migration
  def change
  	remove_column :expense_reports, :expense_report_status_id, :integer
  end
end
