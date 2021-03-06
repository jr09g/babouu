class SpendingTrendsController < ApplicationController
	def charts
    #prevent receipt items tied to an expense report from being returned in graphs
    @expense_reports = ExpenseReport.find(4)

    #Variables for weekly charts
    @current_week_date_range = Date.current.all_week
    @week_receipts = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_week_date_range).where("receipts.expense_report_id" => @expense_reports.id)
    @names_week = @week_receipts.uniq.pluck(:category)
    @names_week.sort!

    @price_avg_week = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_week_date_range).where("receipts.expense_report_id" => @expense_reports.id).group("receipt_items.category").average(:price)
    @price_sum_week = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_week_date_range).where("receipts.expense_report_id" => @expense_reports.id).group("receipt_items.category").sum(:price)
    @avg_week = []
    @sum_week = []

    @price_avg_week.sort.each do |avg|
      @avg_week << avg[1].to_f
    end

    @price_sum_week.sort.each do |sum|
      @sum_week << sum[1].to_f
    end

    @week_sum_total = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_week_date_range).where("receipts.expense_report_id" => @expense_reports.id).sum(:price)

    #Variables for monthly charts
    @current_month_date_range = Date.current.all_month
		@month_receipts = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_month_date_range).where("receipts.expense_report_id" => @expense_reports.id)
		@names_month = @month_receipts.uniq.pluck(:category)
		@names_month.sort!
		
		@price_avg_month = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_month_date_range).where("receipts.expense_report_id" => @expense_reports.id).group("receipt_items.category").average(:price)
		@price_sum_month = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_month_date_range).where("receipts.expense_report_id" => @expense_reports.id).group("receipt_items.category").sum(:price)
    @avg_month = []
    @sum_month = []

    @price_avg_month.sort.each do |avg|
      @avg_month << avg[1].to_f
    end

		@price_sum_month.sort.each do |sum|
		  @sum_month << sum[1].to_f
		end

    @month_sum_total = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_month_date_range).where("receipts.expense_report_id" => @expense_reports.id).sum(:price)

    #Variables for yearly charts
    @current_year_date_range = Date.current.all_year
    @year_receipts = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_year_date_range).where("receipts.expense_report_id" => @expense_reports.id)
    @names_year = @year_receipts.uniq.pluck(:category)
    @names_year.sort!
    
    @price_avg_year = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_year_date_range).where("receipts.expense_report_id" => @expense_reports.id).group("receipt_items.category").average(:price)
    @price_sum_year = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_year_date_range).where("receipts.expense_report_id" => @expense_reports.id).group("receipt_items.category").sum(:price)
    @avg_year = []
    @sum_year = []

    @price_avg_year.sort.each do |avg|
      @avg_year << avg[1].to_f
    end

    @price_sum_year.sort.each do |sum|
      @sum_year << sum[1].to_f
    end

    @year_sum_total = ReceiptItem.joins(:receipt).where(:user_id => current_user.id).where("receipts.plain_date" => @current_year_date_range).where("receipts.expense_report_id" => @expense_reports.id).sum(:price)

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

		@sum_chart_week = LazyHighCharts::HighChart.new('graph') do |f|
  		  f.title(text: "Total Expenses by Category")
  		  f.xAxis(categories: @names_week)
  		  f.series(name: "Sum", yAxis: 0, data: @sum_week)

  		  f.yAxis [
    	  {title: {text: "Amount($)", margin: 70} }
  	  	  ]

  	  	  f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
  	  	  f.chart({defaultSeriesType: "column"})
		end

    @avg_chart_week = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Average Expense by Category")
        f.xAxis(categories: @names_week)
        f.series(name: "Avg", yAxis: 0, data: @avg_week)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "column"})
    end

    @sum_chart_month = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Total Expenses by Category")
        f.xAxis(categories: @names_month)
        f.series(name: "Sum", yAxis: 0, data: @sum_month)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "column"})
    end

    @avg_chart_month = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Average Expense by Category")
        f.xAxis(categories: @names_month)
        f.series(name: "Avg", yAxis: 0, data: @avg_month)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "column"})
    end

    @sum_chart_year = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Total Expenses by Category")
        f.xAxis(categories: @names_year)
        f.series(name: "Sum", yAxis: 0, data: @sum_year)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "column"})
    end

    @avg_chart_year = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Average Expense by Category")
        f.xAxis(categories: @names_year)
        f.series(name: "Avg", yAxis: 0, data: @avg_year)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "column"})
    end

	end

	def biz_trends
    #expenses for all employees for the current year
    @this_year = Date.current.all_year
    @receipt_join = Receipt.joins(:receipt_items).where("receipts.plain_date" => @this_year)
    @relationship_join = @receipt_join.joins("LEFT OUTER JOIN relationships ON relationships.user_id = receipts.user_id")
    @biz_users = @relationship_join.where("relationships.business_id" => current_business.id).where.not("receipts.expense_report_id" => 4)

    @sum_biz = @biz_users.group("receipt_items.category").sum("receipt_items.price")
    @avg_biz = @biz_users.group("receipt_items.category").average("receipt_items.price")

    @names_biz = @biz_users.uniq.pluck("receipt_items.category")
    @names_biz.sort!

    @biz_sum_year = []
    @biz_avg_year = []

    @sum_biz.sort.each do |sum|
      @biz_sum_year << sum[1].to_f
    end

    @avg_biz.sort.each do |avg|
      @biz_avg_year << avg[1].to_f
    end

    #total expenses this year month by month
    #@months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    #@monthly_total = @biz_users.select("date_trunc('month', receipts.plain_date), receipt_items.price").group("month").sum("receipt_items.price")

    #@monthly_array = []

    #@monthly_total.sort.each do |month|
    #  @monthly_array << month[1].to_f
    #end

    #all charts below
    @biz_chart_sum_year = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Total by Category")
        f.xAxis(categories: @names_biz)
        f.series(name: "Sum", yAxis: 0, data: @biz_sum_year)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "column"})
    end

    @biz_chart_avg_year = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Average by Category")
        f.xAxis(categories: @names_biz)
        f.series(name: "Avg", yAxis: 0, data: @biz_avg_year)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "column"})
    end

    #@biz_chart_sum_by_month = LazyHighCharts::HighChart.new('graph') do |f|
    #    f.title(text: "Monthly Total")
    #    f.xAxis(categories: @months)
    #    f.series(name: "Sum", yAxis: 0, data: @monthly_array)

    #    f.yAxis [
    #    {title: {text: "Amount($)", margin: 70} }
    #      ]

    #      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
    #      f.chart({defaultSeriesType: "column"})
    #end
		
	end
end