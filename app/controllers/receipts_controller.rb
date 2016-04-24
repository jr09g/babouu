class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /receipts
  # GET /receipts.json
  def index
    #instance variable to retrieve all records from the user table
    @users = User.all
    #instance variable to retrieve all records from the receipt table
    @receipts = Receipt.all
    #instance variable to retrieve all records from the receipt table; joined with expense_report table to bring view name in
    @receipt_with_view = Receipt.joins(:expense_report).select("receipts.id, receipts.user_id, receipts.company_name, receipts.receipt_desc, receipts.price, expense_reports.name as name, receipts.plain_date")
    #instance variable to call all companies
    #@companies = Company.all
    ###
    @expense_reports = ExpenseReport.all
    #instance variable to group all records by date created
    @receipt_dates = Receipt.select("plain_date as receipt_date, count(date(created_at)) as receipt_count, sum(price) as date_total").group("plain_date")
    #instance variable to group all records by company name
    #@company_receipts = Receipt.joins(:company).select("company_name, count(company_name) as company_count, sum(price) as company_total, company_id, logo").group("company_name, company_id, logo")
    #instance variable below takes summation of prices for the current date only in order to display that sum in the view for the current user
    @current_day_total = Receipt.where(:user_id => current_user.id).select("sum(price) as total").find_by plain_date: Date.current
    #instance variable takes date range of the current month
    @current_month_date_range = Date.current.at_beginning_of_month..Time.now
    #instance variable takes summation of prices for the current month only to display monthly total
    @current_month_total_test = Receipt.where(:plain_date => @current_month_date_range)
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
    @receipt_items = ReceiptItem.all
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
    #below instance variable shows -NONE- and user expense reports in a dropdown to select for a new receipt
    @expense_reports = ExpenseReport.where(user_id: [current_user.id, 0])
  end

  # GET /receipts/1/edit
  def edit
  end

  # POST /receipts
  # POST /receipts.json
  def create
    @tess_file = Receipt.manual_attachment(params[:receipt]['image'].path)
    @man_price = Receipt.manual_price(@tess_file)

    @receipt = current_user.receipts.build(receipt_desc: params[:receipt]['receipt_desc'], company_name: params[:receipt]['company_name'], price: @man_price, expense_report_id: params[:receipt]['expense_report_id'], plain_date: params[:receipt]['plain_date'])#Date.current, image: @tess_file)
    #@receipt = current_user.receipts.build(receipt_desc: @to_txt, price: 0)params[:receipt]['receipt_desc']
    
    respond_to do |format|
      if @receipt.save
        format.html { redirect_to @receipt, notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url, notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_params
      params.require(:receipt).permit(:receipt_desc, :price, :image, :expense_report_id, :plain_date, :company_name)
    end
end
