require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe 'associations' do
    it { should have_many(:payments) }
  end

  describe 'validations' do
    it { should validate_presence_of(:funded_amount)}
  end

  describe 'callbacks' do
    describe "before create" do
      it 'Should set the remaining balance if it is blank' do
        loan = Loan.new(funded_amount: 100)
        loan.save
        expect(loan.remaining_balance).to eq(loan.funded_amount)
      end
      it 'Should not set the remaining balance if it is provided' do
        loan = Loan.new(funded_amount: 100, remaining_balance: 30)
        loan.save
        expect(loan.remaining_balance).to eq(30)
      end
    end
  end

  describe '#decrement_remaining_balance' do
    let(:loan) { Loan.create!(funded_amount: 100) }
    it 'Should decrement the loans remaining balance by the amount provided' do
      loan.decrement_remaining_balance(33)
      expect(loan.remaining_balance).to eq(67)
    end
  end
end
