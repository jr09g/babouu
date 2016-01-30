class RemoveStatusIndFromExpenseReports < ActiveRecord::Migration
  def change
  	remove_column :expense_reports, :status_ind, :integer
  end
end
