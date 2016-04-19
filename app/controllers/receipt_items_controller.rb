class ReceiptItemsController < ApplicationController
  before_action :set_receipt_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
  end

  def new
  	@receipt_item = ReceiptItem.new
  end

  def create
  	@receipt_item = current_user.receipt_items.build(receipt_item_params)

    respond_to do |format|
      if @receipt_item.save
        format.html { redirect_to receipt_receipt_items_url, notice: 'Receipt item was successfully created.' }
        format.json { render :show, status: :created, location: receipt_receipt_items_urlm }
      else
        format.html { render :new }
        format.json { render json: @receipt_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
  	respond_to do |format|
      if @receipt_item.update(receipt_item_params)
        format.html { redirect_to @receipt_item, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt_item }
      else
        format.html { render :edit }
        format.json { render json: @receipt_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@receipt_item.destroy
    respond_to do |format|
      format.html { redirect_to receipt_items_url, notice: 'Receipt item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_receipt_item
  	@receipt_item = ReceiptItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def receipt_item_params
  	params.require(:receipt_item).permit(:description, :price, :category)
  end

end