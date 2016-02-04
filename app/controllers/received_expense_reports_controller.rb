class ReceivedExpenseReportsController < ApplicationController
  before_action :set_received_expense_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  def index
    @received_expense_reports = ExpenseReport.where(:manager_id => current_user.id)
  end

  def show
  end

  def new
    
  end

  def edit
  end

  def create

  end

  # PATCH/PUT /received_expense_reports/1
  # PATCH/PUT /received_expense_reports/1.json
  def update
    respond_to do |format|
      if @received_expense_report.update(received_expense_report_params)
        format.html { redirect_to @received_expense_report, notice: 'Received expense report was successfully updated.' }
        format.json { render :show, status: :ok, location: @received_expense_report }
      else
        format.html { render :edit }
        format.json { render json: @received_expense_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /received_expense_reports/1
  # DELETE /received_expense_reports/1.json
  def destroy

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_received_expense_report
      @expense_report = ExpenseReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def received_expense_report_params
      params.require(:expense_report).permit(:status)
    end
end
