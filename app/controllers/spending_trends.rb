class SpendingTrendsController < ApplicationController
	def charts
		@user_receipts = Receipt.where(:user_id => current_user.id)
		@names = @user_receipts.uniq.pluck(:company_name)
		@final = []

		@prices = Receipt.where(:user_id => current_user.id).group(:company_name).average(:price)
		#@prices_avg = @prices.pluck(:price)

		@prices.each do |avg|
		  @final << avg[1].to_digit
		end

		#@company_receipts = Receipt.joins(:company)
		#@companies = Receipt.joins(:company).group_by_day(:plain_date, range: 1.week.ago.midnight..Time.now)
		@chart = LazyHighCharts::HighChart.new('graph') do |f|
  		  f.title(text: "Population vs GDP For 5 Big Countries [2009]")
  		  f.xAxis(categories: ["United States", "Japan", "China", "Germany", "France"])
  		  f.series(name: "GDP in Billions", yAxis: 0, data: [14119, 5068, 4985, 3339, 2656])
  		  f.series(name: "Population in Millions", yAxis: 1, data: [310, 127, 1340, 81, 65])

  		  f.yAxis [
    	  {title: {text: "GDP in Billions", margin: 70} },
    	  {title: {text: "Population in Millions"}, opposite: true},
  	  	  ]

  	  	  f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
  	  	  f.chart({defaultSeriesType: "column"})
		end

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

		@test = LazyHighCharts::HighChart.new('graph') do |f|
  		  f.title(text: "Average Transaction Per Company")
  		  f.xAxis(categories: @names)
  		  f.series(name: "Sample Avg", yAxis: 0, data: @final)
  		  f.series(name: "Population in Millions", yAxis: 1, data: [310, 127, 1340, 81, 65])

  		  f.yAxis [
    	  {title: {text: "Sample Avg", margin: 70} },
    	  {title: {text: "Population in Millions"}, opposite: true},
  	  	  ]

  	  	  f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
  	  	  f.chart({defaultSeriesType: "column"})
		end
	end

	def companies
		#@company_receipts = Receipt.joins
	end
end