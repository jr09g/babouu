class CreateExpenseReportStatus < ActiveRecord::Migration
  def change
    create_table :expense_report_statuses do |t|
      t.string :name
    end
  end
end
