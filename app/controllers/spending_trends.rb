class SpendingTrendsController < ApplicationController
	def charts
		@receipts = Receipt.all
		#@company_receipts = Receipt.joins(:company)
		#@companies = Receipt.joins(:company).group_by_day(:plain_date, range: 1.week.ago.midnight..Time.now)
	end

	def companies
		#@company_receipts = Receipt.joins
	end
end