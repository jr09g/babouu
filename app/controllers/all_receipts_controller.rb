class AllReceiptsController < ApplicationController
  def index
  	#instance variable to retrieve all records from the user table
	#@users = User.all
	#instance variable to retrieve all records from the receipt table; joined with expense_report table to bring view name in
    @receipt_with_view = Receipt.joins(:expense_report).select("receipts.id, receipts.user_id, receipts.company_name, receipts.receipt_desc, receipts.price, expense_reports.name as name, receipts.plain_date, receipts.created_at")
	#instance variable to retrieve all records from the receipt table in descending order
	#@receipts = Receipt.order(created_at: :desc)
	#
	#@receipts = @receipt_with_view.order(created_at: :desc)
	#instance variable to group dates for receipts so that all receipts can be sectioned off into those dates
	@receipt_dates = Receipt.select("plain_date, sum(price) as price_by_date").group("plain_date").order(plain_date: :desc)
  end
end
