class AddStatusIndToExpenseReports < ActiveRecord::Migration
  def change
    add_column :expense_reports, :status_ind, :integer
  end
end
