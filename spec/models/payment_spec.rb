require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:loan) {Loan.create!(funded_amount: 100)}
  let(:paid_off_loan) { Loan.create!(funded_amount: 100, remaining_balance: 1) }

  describe 'associations' do
    it { should belong_to(:loan) }
  end

  describe 'validations' do
    let(:paid_off_loan) { Loan.create!(funded_amount: 100, remaining_balance: 1) }
    it 'is valid if amount is less than loan balance' do
      payment = Payment.new(loan: loan, payment_date: Date.today, amount: 50)
      expect(payment.save).to be_truthy
    end
    it 'is not valid if amount is greater than loan balance' do
      payment = Payment.new(loan: paid_off_loan, payment_date: Date.today, amount: 50)
      expect{payment.save!}.to raise_error (ActiveRecord::RecordInvalid)
    end
  end
  describe 'callbacks' do
    describe "after create" do
      before do
        allow(loan).to receive(:decrement_remaining_balance).and_call_original
      end
      it 'should call decrement_remaining_balance on its loan' do
        Payment.create!(loan: loan, payment_date: Date.today, amount: 10)
        expect(loan).to have_received(:decrement_remaining_balance).with(10)
      end
      it 'should not call dedecrement_remaining_balance on its loan if it fails to be created' do
        payment = Payment.new(loan: paid_off_loan, payment_date: Date.today, amount: 50)
        payment.save
        expect(loan).not_to have_received(:decrement_remaining_balance).with(50)
      end
    end
  end
end
