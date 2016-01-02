class Company < ActiveRecord::Base
	has_many :receipts
end
