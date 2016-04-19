class ReceiptItemsController < ApplicationController
  before_action :set_receipt_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
  end

  def new
  	@receipt_item = ReceiptItem.new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
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