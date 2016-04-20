class Receipt < ActiveRecord::Base
  require 'rtesseract'
  require 'mini_magick'
  require 'net/http'
  belongs_to :company
  belongs_to :user
  belongs_to :expense_report
  has_many :receipt_items
  validates :receipt_desc, :price, :presence => true
  has_attached_file :image
  #:styles => {:medium => "300x300>", :thumb => "100x100"}
  #validates_attachment_content_type :image, :content_type=>/\Aimage\/.*\Z/
  do_not_validate_attachment_file_type :image

  #
  ### below set of methods validate the email coming in to ensure it is the correct receipt email before being saved
  #
  #

	#below method checks to make sure that the email is a valid receipt and not another email from the same domain ex: shipping and packing notice
	def self.proper_email(company_name)
		@company_name = company_name 

	end

	#below method checks whether the email being sent was previusly saved in the system
	def self.is_duplicate(user, in_reply_to)
		#leverage in-reply-to param, as it is a unique key for each email
		@in_reply_to = in_reply_to
		@user = user
		#default this value to false in event that there are o receipts to loop through
		@duplicate = false

		#loop through each receipt
		Receipt.all.each do |receipt|
		  #first check is to make sure we only check receipts belonging to the current user
		  if @user == receipt.user_id
			#second check validates that the unique email key is not currently stored in the db
			if @in_reply_to == receipt.in_reply_to
			  #if it is a duplicate, return true
			  @duplicate = true
			  break
			else
			  #if the key cannot be found, it is not a duplicate; return false
			  @duplicate = false
			end
		  else
			#if user cannot be found, do nothing
			##THIS SHOULD NEVER HAPPEN
		  end
		end

		return @duplicate 

	end

	#
	#
	### below set of methods retreive various parts of the email request and parses the relevant information
	#
	#

	#below method should be changed to one that ties receipts brought in to the appropriate user by looking for the user email's domain
	def self.parse_user(body)
		@body = body
		@user

		User.all.each do |user|
			if @body == user.email
				@user = user.id 
			end
		end

		return @user
	end

	#below method parses first portion of body to retrieve company name
	def self.company_name_parse(body)
		@body = body
		@body_string = @body.split(" ")
		@company_name = []
		@company_name_final

		#below loop extracts the entire domain associated with the company
		@body_string.each do |string|
		  @company_name << string
		  if string.include? '@'
			break
		  end
		end

		#below deletes first element of array, an extended underscore
		@company_name.delete_at(0)
		#below deletes the new first element of array, 'from:'
		@company_name.delete_at(0)
		#below deletes final element of array, the full email address
		@company_name.delete_at(-1)
		#below joins the remaining elements of the array into a string; all that should remain should be the company name
		@company_name_final = @company_name.join(" ")

		return @company_name_final

	end

	#the below method takes the email subject and returns it
	def self.receipt_desc_parse(description)
		@description = description

		return @description 
	end

	#below method takes the body and returns the text
	def self.body_parse(body)
		@body = body

		return @body 
	end

	#the below method parses the body and retrieves the total price of the receipt. It should return the final price in the body
	def self.price_parse(body_price)
		@body_price = body_price
		@price_array
		@final_price

		#remove all commas from the body before performing regex; this allows for numbers with commas to be accurately placed on a receipt
		@body_price_no_commas = @body_price.tr(',','')
		#below line takes the body and uses regex to find all digits that are numbers to two decimal places and creates an array
		@price_array = @body_price_no_commas.scan(/(\d+[.]\d{2}(\s|\z))/)

		#below statement checks if the email returned any prices; if not, then 0 is returned; this is ok beause this is not a valid email
		if @price_array.all? {|i| i.nil? or i == ""}
			@price_array = 0
			@final_price = @price_array
		else
			#below line converts the contents of the array to floating point numbers
			@price_array.flatten!.collect! {|i| i.to_f}
			#below line retrieves the largest number in the array. The assumption here is that this number is the grand total for the receipt
			@final_price = @price_array.max
		end

		#The final number is then returned as the result of the method
		return @final_price
	end

	#below method takes the email's attachments and extracts the price
	def self.price_attachment_parse(attachment)

	end

	#below method creates an html file from the contents of the email and saves it as an attachment that will be stored in S3 as in Paperclip
	def self.file_attachment(description, body)

		@temp_file = Tempfile.new(['email_receipt', '.pdf'])
		@temp_file.write(description)
		@temp_file.write(body)
		@temp_file.rewind

		return @temp_file
	end

	def self.in_reply_to(in_reply_to)
		@in_reply_to = in_reply_to

		return @in_reply_to
	end

	#
	#
	#below are the methods required to process manual receipts
	#
	#

	#below method digitizes the incoming receipt and uses this to provide text for further analysis
	def self.manual_attachment(file_name)
		@file_name = file_name

		#bash command that converts the receipt attachment to a .tiff file, so that rtesseract is able to convert the file
		@to_tiff = system('convert -density 300 ' + @file_name + ' -depth 8 ' + @file_name.sub(/\.[^.]+\z/, ".tiff"))

		#converts the tiff file from the previous command and converts to a temporary .txt file
		@image = RTesseract.new(@file_name.sub(/\.[^.]+\z/, ".tiff"), :processor => "mini_magick")

		#TEST TO BE ABLE TO SEE TEXT CREATED FOR ABOVE 
		#@temp_file = Tempfile.new(['ocr', '.txt'])
		#@temp_file.write(@image.to_s)
		#@temp_file.rewind

		#return @temp_file
		return @image.to_s
	end

	#below method will take the digitized receipt and return the price
	def self.manual_price(body_price)
	  @body_price = body_price
	  @price_array
	  @final_price

	  #remove all commas from the body before performing regex; this allows for numbers with commas to be accurately placed on a receipt
	  @body_price_no_commas = @body_price.tr(',','')
	  #below line takes the body and uses regex to find all digits that are numbers to two decimal places and creates an array
	  @price_array = @body_price_no_commas.scan(/(\d+[.]\d{2}(\s|\z))/)

	  #below statement checks if the email returned any prices; if not, then 0 is returned; this is ok beause this is not a valid email
	  if @price_array.all? {|i| i.nil? or i == ""}
		@price_array = 0
		@final_price = @price_array
	  else
	    #below line converts the contents of the array to floating point numbers
		@price_array.flatten!.collect! {|i| i.to_f}
		#below line retrieves the largest number in the array. The assumption here is that this number is the grand total for the receipt
	    @final_price = @price_array.max
	  end

	  #The final number is then returned as the result of the method
	  return @final_price

	end

end
