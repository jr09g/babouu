class ExpenseReportStatusesController < ApplicationController
  before_action :set_expense_report_status, only: [:show, :edit, :update, :destroy]

  # GET /expense_report_statuses
  # GET /expense_report_statuses.json
  def index
    @expense_report_statuses = ExpenseReportStatus.all
  end

  # GET /expense_report_statuses/1
  # GET /expense_report_statuses/1.json
  def show
  end

  # GET /expense_report_statuses/new
  def new
    @expense_report_status = ExpenseReportStatus.new
  end

  # GET /expense_report_statuses/1/edit
  def edit
  end

  # POST /expense_report_statuses
  # POST /expense_report_statuses.json
  def create
    @expense_report_status = ExpenseReportStatus.new(expense_report_status_params)

    respond_to do |format|
      if @expense_report_status.save
        format.html { redirect_to @expense_report_status, notice: 'Expense report status was successfully created.' }
        format.json { render :show, status: :created, location: @expense_report_status }
      else
        format.html { render :new }
        format.json { render json: @expense_report_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expense_report_statuses/1
  # PATCH/PUT /expense_report_statuses/1.json
  def update
    respond_to do |format|
      if @expense_report_status.update(expense_report_status_params)
        format.html { redirect_to @expense_report_status, notice: 'Expense report status was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense_report_status }
      else
        format.html { render :edit }
        format.json { render json: @expense_report_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expense_report_statuses/1
  # DELETE /expense_report_statuses/1.json
  def destroy
    @expense_report_status.destroy
    respond_to do |format|
      format.html { redirect_to expense_report_statuses_url, notice: 'Expense report status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense_report_status
      @expense_report_status = ExpenseReportStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_report_status_params
      params[:expense_report_status]
    end
end
