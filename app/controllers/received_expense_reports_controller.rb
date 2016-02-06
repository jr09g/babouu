class ReceivedExpenseReportsController < ApplicationController
  before_action :set_received_expense_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  def index
    @received_expense_reports = ExpenseReport.where(:manager_id => current_user.id)
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
