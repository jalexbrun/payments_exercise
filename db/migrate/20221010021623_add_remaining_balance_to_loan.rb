class AddRemainingBalanceToLoan < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :remaining_balance, :decimal, precision: 8, scale: 2
  end
end
