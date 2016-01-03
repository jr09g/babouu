class ExpenseReportAuthorizer < ApplicationAuthorizer
  
  def self.sendable_by?(user)
  	user.employee? || user.manager?
  end

  def self.receivable_by?(user)
  	user.manager?
  end

  def self.acceptable_by?(user)
  	user.manager?
  end

  def self.rejectable_by?(user)
  	user.manager?
  end

end