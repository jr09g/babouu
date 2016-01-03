class AddUserIdToExpenseReports < ActiveRecord::Migration
  def change
    add_column :expense_reports, :user_id, :integer
    add_index :expense_reports, :user_id
  end
end
