class ExpenseReportsController < ApplicationController
  before_action :set_expense_report, only: [:show, :edit, :update, :destroy]

  # GET /expense_reports
  # GET /expense_reports.json
  def index
    @expense_reports = ExpenseReport.all
  end

  # GET /expense_reports/1
  # GET /expense_reports/1.json
  def show
  end

  # GET /expense_reports/new
  def new
    @expense_report = ExpenseReport.new
  end

  # GET /expense_reports/1/edit
  def edit
  end

  # POST /expense_reports
  # POST /expense_reports.json
  def create
    @expense_report = ExpenseReport.new(expense_report_params)

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
        format.html { redirect_to @expense_report, notice: 'Expense report was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense_report }
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
      params.require(:expense_report).permit(:name, :start_date, :end_date)
    end
end
