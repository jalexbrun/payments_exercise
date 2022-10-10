class Payment < ActiveRecord::Base
  after_create :decrement_loan_balance

  belongs_to :loan

  validate :payment_amount_less_than_remaining_balance


  private
  def payment_amount_less_than_remaining_balance
    if loan.present? && amount > loan.remaining_balance
      errors.add(:amount, "cannot be greater than remaining balance of loan (#{loan.remaining_balance})")
    end
  end

  def decrement_loan_balance
    loan.decrement_remaining_balance(amount)
  end
end
