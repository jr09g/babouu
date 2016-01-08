class AllReceiptsController < ApplicationController
  def index
  	#instance variable to retrieve all records from the user table
	@users = User.all
	#instance variable to retrieve all records from the receipt table in descending order
	@receipts = Receipt.order(created_at: :desc)
	#insacne variable to group dates for receipts so that all receipts can be sectioned off into those dates
	@receipt_dates = Receipt.select("plain_date, sum(price) as price_by_date").group("plain_date").order(plain_date: :desc)
  end
end
