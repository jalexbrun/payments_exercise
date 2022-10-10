class BackfillRemainingBalance < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def up
    Loan.where(remaining_balance: nil).in_batches.update_all('remaining_balance = funded_amount')
  end
end
