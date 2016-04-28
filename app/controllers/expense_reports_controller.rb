class ExpenseReportsController < ApplicationController
  before_action :set_expense_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @expense_reports = ExpenseReport.all
  end

  def show
    #Variables for expense report
    @expense_report_receipts = ReceiptItem.joins(:receipt).where("receipts.expense_report_id" => @expense_report.id)
    @names_expense_report = @expense_report_receipts.uniq.pluck(:category)
    @names_expense_report.sort!

    @price_avg_report = ReceiptItem.joins(:receipt).where("receipts.expense_report_id" => @expense_report.id).group("receipt_items.category").average(:price)
    @price_sum_report = ReceiptItem.joins(:receipt).where("receipts.expense_report_id" => @expense_report.id).group("receipt_items.category").sum(:price)
    @avg_report = []
    @sum_report = []

    @price_avg_report.sort.each do |avg|
      @avg_report << avg[1].to_f
    end

    @price_sum_report.sort.each do |sum|
      @sum_report << sum[1].to_f
    end

    @sum_chart_report = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Total Expenses by Category")
        f.xAxis(categories: @names_expense_report)
        f.series(name: "Sum", yAxis: 0, data: @sum_report)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "pie"})
    end

    @avg_chart_report = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Average Expense by Category")
        f.xAxis(categories: @names_expense_report)
        f.series(name: "Avg", yAxis: 0, data: @avg_report)

        f.yAxis [
        {title: {text: "Amount($)", margin: 70} }
          ]

          f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
          f.chart({defaultSeriesType: "column"})
    end


  end

  def new
    @expense_report = ExpenseReport.new
    #below variable sets status id to in progress for all new reports
    @expense_report.status = "in progress"
  end

  def edit
    #instance variable to show all receipts under the selected expense report
    @receipts = Receipt.all
    #instance variable is for pie chart to be created
    @expense_report_receipts = Receipt.joins(:expense_report).select("name, receipt_desc, expense_report_id, price, plain_date, company_name")
    #
    @receipts_view_total = 0.00
  end

  def create
    @expense_report = current_user.expense_reports.build(expense_report_params)

    respond_to do |format|
      if @expense_report.save
        format.html { redirect_to @expense_report, notice: 'Expense report was successfully created.' }
        format.json { render :show, status: :created, location: @expense_report }
      else
        format.html { render :new }
        format.json { render json: @expense_report.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @expense_report.update(expense_report_params)
        if @expense_report.status == "sent"
          #find the group that the user belongs to
          @user_group = UsersGroup.where(:user_id => current_user.id).take
          #find the group using the group id
          @group_manager = Group.find(@user_group.group_id)
          #update the expense report by adding the group's manager
          @expense_report.update(:manager_id => @group_manager.manager_user_id)
          #
          #once updated, redirect to expense report show view
          #format.html { redirect_to @expense_report, notice: 'Expense report was successfully updated.' }
          format.html { render :edit, notice: 'Status updated to #{@expense_report.status}' }
          format.json { render :show, status: :ok, location: @expense_report }
        else
          format.html { redirect_to @expense_report, notice: 'Expense report was successfully updated.' }
          format.json { render :show, status: :ok, location: @expense_report }
        end
      else
        format.html { render :edit }
        format.json { render json: @expense_report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @expense_report.destroy
    respond_to do |format|
      format.html { redirect_to expense_reports_url, notice: 'Expense report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense_report
      @expense_report = ExpenseReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_report_params
      params.require(:expense_report).permit(:name, :start_date, :end_date, :status)
    end
end
