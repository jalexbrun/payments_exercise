class Loan < ActiveRecord::Base
  before_create :set_remaining_balance

  has_many :payments, :dependent => :destroy

  #since we need a funded amount for creating payments, and for calculating the remaining balance, we need to add this
  validates :funded_amount, presence: true

  def decrement_remaining_balance(amount)
    decrement!(:remaining_balance, amount)
  end

  private
  def set_remaining_balance
    self.remaining_balance = self.funded_amount if self.remaining_balance.blank?
  end
end
