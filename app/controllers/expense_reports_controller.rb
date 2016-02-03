class ExpenseReportsController < ApplicationController
  before_action :set_expense_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /expense_reports
  # GET /expense_reports.json
  def index
    @expense_reports = ExpenseReport.all
  end

  # GET /expense_reports/1
  # GET /expense_reports/1.json
  def show
    #instance variable to show all receipts under the selected expense report
    @receipts = Receipt.all
    #instance variable is for pie chart to be created
    @expense_report_receipts = Receipt.joins(:expense_report).select("name, receipt_desc, expense_report_id, price, plain_date, company_name")
    #
    @receipts_view_total = 0.00
  end

  # GET /expense_reports/new
  def new
    @expense_report = ExpenseReport.new
    #below variable sets status id to in progress for all new reports
    @expense_report.status = "in progress"
  end

  # GET /expense_reports/1/edit
  def edit
  end

  # POST /expense_reports
  # POST /expense_reports.json
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

  # PATCH/PUT /expense_reports/1
  # PATCH/PUT /expense_reports/1.json
  def update

    respond_to do |format|
      if @expense_report.update(expense_report_params)
        if @expense_report.status == "sent"
          @user_group = UsersGroup.where(:user_id => current_user.id)
          @group = @user_group.group_id
          @group_manager = Group.find(@group)
          @expense_report.update(:manager_id => @group_manager.manager_user_id)
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

  # DELETE /expense_reports/1
  # DELETE /expense_reports/1.json
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
