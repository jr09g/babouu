class SpendingTrendsController < ApplicationController
	def charts
    #Variables for weekly charts
    @current_week_date_range = Date.current.all_week
    @week_receipts = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_week_date_range)
    @names_week = @week_receipts.uniq.pluck(:category)
    @names_week.sort!

    #Variables for monthly charts
    #@current_month_date_range = Date.current.all_month
		#@month_receipts = Receipt.where(:user_id => current_user.id).where(:plain_date => @current_month_date_range)
		#@names_month = @month_receipts.uniq.pluck(:company_name)
		#@names_month.sort!
		@final = []
		#@price_avg = Receipt.where(:user_id => current_user.id).where(:plain_date => @current_month_date_range).group(:company_name).average(:price).select("receipt_items.category, sum(receipt_items.price) as total")
		@price_sum = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_week_date_range).group("receipt_items.category").sum(:category)

		#@price_avg.each do |avg|
		#  @final << avg[1].to_f
		#end

		#@company_receipts = Receipt.joins(:company)
		#@companies = Receipt.joins(:company).group_by_day(:plain_date, range: 1.week.ago.midnight..Time.now)

		@chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
  		  f.global(useUTC: false)
  		  f.chart(
    		backgroundColor: {
      		linearGradient: [0, 0, 500, 500],
      		stops: [
        	  [0, "rgb(255, 255, 255)"],
        	  [1, "rgb(240, 240, 255)"]
      		]
    		},
    		borderWidth: 2,
    		plotBackgroundColor: "rgba(255, 255, 255, .9)",
    		plotShadow: true,
    		plotBorderWidth: 1
  		  )
  		  f.lang(thousandsSep: ",")
  		  f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
		end

		@avg_chart = LazyHighCharts::HighChart.new('graph') do |f|
  		  f.title(text: "Expenses by Line Item")
  		  f.xAxis(categories: @names_week)
  		  f.series(name: "Sum", yAxis: 0, data: @price_sum)

  		  f.yAxis [
    	  {title: {text: "Amount($)", margin: 70} }
  	  	  ]

  	  	  f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
  	  	  f.chart({defaultSeriesType: "column"})
		end

		#@test_pie = LazyHighCharts::HighChart.new('graph') do |f|
  		#  f.title(text: "Total by Company")
  		#  f.xAxis(categories: @names)
  		#  f.series(name: "Average Transaction", yAxis: 0, data: @final)

  		#  f.yAxis [
    	#  {title: {text: "Amount($)", margin: 70} },
  	  	#  ]

  	  	#  f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
  	  	#  f.chart({defaultSeriesType: "pie"})
		#end
	end

	def companies
		#@company_receipts = Receipt.joins
	end
end