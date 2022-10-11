require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:loan) { Loan.create!(funded_amount: 100) }
  let(:today) {Date.today}
  describe '#index' do
    it 'responds with a 200' do
      get :index, params: {loan_id: loan.id}
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:payment) { Payment.create!(loan: loan, payment_date: today, amount: 50.0 )}

    it 'responds with a 200' do
      get :show, params: { id: payment.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    it 'should respond with a new payment if successful' do
      post :create, params: { loan_id: loan.id, payment: { amount: 50, payment_date: today } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("loan_id" => 1, "amount" => "50.0", "payment_date" => today.strftime)
    end

    it 'should respond with a validation errors if unsuccessful' do
      post :create, params: { loan_id: loan.id, payment: { amount: 500, payment_date: today } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({"amount" => ["cannot be greater than remaining balance of loan (#{loan.remaining_balance})"]})
    end
  end
end
