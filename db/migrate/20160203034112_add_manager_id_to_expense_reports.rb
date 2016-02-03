class AddManagerIdToExpenseReports < ActiveRecord::Migration
  def change
    add_column :expense_reports, :manager_id, :integer
  end
end
