class DropExpenseReportStatusTable < ActiveRecord::Migration
  def change
  	drop_table :expense_report_statuses
  end
end
