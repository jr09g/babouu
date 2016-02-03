class AddStatusToExpenseReports < ActiveRecord::Migration
  def change
    add_column :expense_reports, :status, :string
  end
end
