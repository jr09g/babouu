class IncomingMailsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  #below method creates a new receipt from a user forwarded email via a POST request hook from Cloudmailin
  #the relevant information is parsed and saved to the receipt
  def create
  	#below instance variable saves the company name from the email parameters
	@company_name = Receipt.company_name_parse(params[:plain], params[:headers]['Thread-Topic'])
	#below instance variable saves the receipt description
	@receipt_desc = Receipt.receipt_desc_parse(params[:headers]['Thread-Topic'])
	#below instance variable saves the body of the email
	@body = Receipt.body_parse(params[:plain])
	#below instance variable saves the price from the email body
	@price = Receipt.price_parse(params[:plain])
	#below instance variable saves the user_id
	@receipt_user = Receipt.parse_user(params[:envelope]['from'])
	#below instance variable saves the company id
	@company_id = Receipt.company_id_retrieve(@company_name)
	#below instance variable sets the path for the email attachment
	@attachment = Receipt.file_attachment(params[:headers]['Thread-Topic'], params[:plain])
	#below instance variable saves the unique key that applies to an individual email; will be used to track if an email is a duplicate of an existing receipt
	@in_reply_to = Receipt.in_reply_to(params[:headers]['In-Reply-To'])
	#below instance variable will return a boolean to confirm if the email received has already been converted into a receipt in the current db
	@is_duplicate = Receipt.is_duplicate(@receipt_user, @in_reply_to)
	#below instance variable retrieves the full email domain for an amazon check
	@email_check = Receipt.amzn_ship_mail_check(@body)

	#below if statement checks to see if the is_duplicate method is true or false, then decide whether a receipt is created based on this
	if @is_duplicate == false
	  #if @company_name == 'Amazon'
		#if @email_check == 'auto-confirm@amazon.com'
		  #@auto_receipt = Receipt.create(receipt_desc: @receipt_desc, company_name: @company_name, price: @price, user_id: @receipt_user, company_id: @company_id, expense_report_id: 4, plain_date: Date.current, image: @attachment, in_reply_to: @in_reply_to)
		#else
		  #do nothing, it is not a valid domain for amazon order confirmation
		#end
	  #elsif @company_name == 'Tennis Warehouse'
		#if @receipt_desc == 'Tennis Warehouse Shipment'
		  #do nothing, emails from Tennis Warehouse using this subject are only shipping notices, not receipts
		#else
		  #@auto_receipt = Receipt.create(receipt_desc: @receipt_desc, company_name: @company_name, price: @price, user_id: @receipt_user, company_id: @company_id, expense_report_id: 4, plain_date: Date.current, image: @attachment, in_reply_to: @in_reply_to)
		#end
	  #elsif @company_name == "NOT VALID"
		#do nothing, the domain does not correspond to a company, and is therefore not a valid receipt
	  #else
		#company name matches one from a list and is therefore a receipt; create receipt record
		@auto_receipt = Receipt.create(receipt_desc: @receipt_desc, company_name: @company_name, price: @price, user_id: @receipt_user, company_id: @company_id, expense_report_id: 4, plain_date: Date.current, image: @attachment, in_reply_to: @in_reply_to)
	  #end
	    render :text => 'success', :status => 200
	else
	  #do nothing; if email is a duplicate, no new receipt will be created
	  render :text => 'success', :status => 200
	end
  end
end
