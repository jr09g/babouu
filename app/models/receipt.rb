class Receipt < ActiveRecord::Base
  require 'rtesseract'
  require 'mini_magick'
  belongs_to :company
  belongs_to :user
  belongs_to :expense_report
  validates :receipt_desc, :price, :presence => true
  has_attached_file :image
  #:styles => {:medium => "300x300>", :thumb => "100x100"}
  #validates_attachment_content_type :image, :content_type=>/\Aimage\/.*\Z/
  do_not_validate_attachment_file_type :image

  #
  ### below set of methods validate the email coming in to ensure it is the correct receipt email before being saved
  #
  #

	#below method checks to make sure that the email is a vailid receipt and not another email from the same domain ex: shipping and packing notice
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

	#below method checks the amazon domain as part of the first check that it is an order email
	def self.amzn_ship_mail_check(body)
		@body = body
		@body_array = @body.split(" ")
		@domain = ""

		#below loop extracts the entire domain associated with the company to store it into the domain instance variable
		@body_array.each do |string|
			if string.include? '@'
				@domain = string
				break
			end
		end

		return @domain
		
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

	#the below method parses the body of the email and retrieves the company domain name and matches that domain name with the company name in the seed table
	def self.company_name_parse(body, receipt_topic)
		@body = body
		@receipt_topic = receipt_topic
		@body_string = @body.split(" ")
		@company_domain = ""
		@final_domain = []
		@check_domain = []
		@final_string = ""
		@company_name_final = ""

		#below loop extracts the entire domain associated with the company
		@body_string.each do |string|
			if string.include? '@'
				@company_domain = string
				break
			end
		end

		#once domain is retrieved, it is split into an array
		@domain_string = @company_domain.split(//)

		#below if statement deletes the domain brackets if the array contains them
		if @domain_string[0] == '<'
			#first bracket is deleted
			@domain_string.delete_at(0)
			#final bracket is deleted
			@domain_string.pop
	    end

	    #array is reversed so for the following loop to work as intended
	    @domain_string.reverse!

		#below loop pushes each element of the domain_string array to a new instance variable up until the @ sign
		@domain_string.each do |char|
			@final_domain.push(char)
			if char == '@'
				break
			end
		end

		#the new array is reversed back into the correct order, then joined into a single string
		@final_domain.reverse!
		@final_string = @final_domain.join("")

		#loop goes through each company record, and if the domain matches the domain retrieved from this method, the company name
		#is stored
		Company.all.each do |company|
			if @final_string == company.email_domain
				if company.email_domain == '@messaging.squareup.com'
					#something
					@topic_array = @receipt_topic.split(" ")
					@topic_array.delete("Receipt")
					@topic_array.delete("from")
					@company_name_final = @topic_array.join(" ")
					break
				else
					@company_name_final = company.name
					break
				end
			else
				#if no domain matches any values from the company list, NOT VALID is returned
				@company_name_final = "NOT VALID"
			end
		end

		#once the loop ends, the company name is returned
		return @company_name_final
	end

	#the below method takes the email subject and returns it
	def self.receipt_desc_parse(description)
		@description = description

		return @description 
	end

	#below method takes the body and 
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

	#below method parses price from a hyperlink located in the body; this is determined by price_in value in company record
	def self.price_link_parse(body)
		@body = body
		@body_string = @body.split(" ")

		@body_string.each do |word|
			if word.include? 'here'
				word.slice!(0,4)
				word.slice!(0,1)
				word.chomp!('>')
				@link = word
				break
			end
		end

		@url = RestClient.get @link 
		@url_body = @url.body
		@url_body_no_commas = @url_body.tr(',','')
		@url_price_array = @url_body_no_commas.scan(/(\d+[.]\d{2}(\s|\z))/)

		if @url_price_array.all? {|i| i.nil? or i == ""}
			@url_price_array = 0
			@final_price = @price_array
		else
			#below line converts the contents of the array to floating point numbers
			@url_price_array.flatten!.collect! {|i| i.to_f}
			#below line retrieves the largest number in the array. The assumption here is that this number is the grand total for the receipt
			@final_price = @price_array.max
		end

		return @final_price

	end

	#below method takes the email's attachments and extracts the price
	def self.price_attachment_parse(attachment)

	end

	#below method returns the id of a company and applies it to company_id in the receipt table
	def self.company_id_retrieve(company_name)
		@company_name = company_name
		@company_id_final

		Company.all.each do |company|
			if @company_name == company.name
				@company_id_final = company.id
			end
		end

		return @company_id_final
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

	#below method digitizes the incoming receipt and saves that to AWS
	def self.manual_info_retrieve(file_name)
		@file_name = file_name

		@image = RTesseract.new(@file_name, :processor => "none")

		#@temp_file = Tempfile.new(['ocr', '.pdf'])
		#@temp_file.write(@image.to_s)
		#@temp_file.rewind

		return @image.to_s
	end

	#below method digitizes the incoming receipt and saves that to AWS
	def self.manual_attachment(file_name)
		@file_name = file_name

		#@image = RTesseract.new("../images/target_test.jpeg", :processor => "mini_magick")
		@image = RTesseract.new(@file_name, :processor => "none")

		@temp_file = Tempfile.new(['ocr', '.pdf'])
		@temp_file.write(@image.to_s)
		@temp_file.rewind

		return @temp_file
	end

	#below method will take the digitized receipt and return the price
	def self.manual_price(digitized_file)
	  @body_price = digitized_file
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

	#below method will take the digitized receipt and return the company name; this will in turn be used to rturn the company id
	def self.manual_company_name(digitized_file)

	end

	#below method will take the company name returned from the above method and return the company id for the receipt
	def self.manual_company_id(company_name)

	end

	#below method will return a receipt description from the digitized receipt
	def self.manual_description(digitized_file)

	end

	#
	#
	#below are the methods for any new companies that subscribe to have receipts created and sent to the app as emails
	#
	#

	def self.sample(sample)

	end

end
