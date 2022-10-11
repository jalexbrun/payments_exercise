class PaymentsController < ActionController::API
  before_action :get_loan, only: [:index, :create]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def index
    render json: @loan.payments
  end

  def show
    render json: Payment.find(params[:id])
  end

  def create
    payment = Payment.new(loan: @loan, amount: payment_params[:amount], payment_date: payment_params[:payment_date])
    if payment.save
      render json: payment, status: :created, location: payment_url(payment)
    else
      render json: payment.errors, status: :unprocessable_entity
    end
  end

  private
  def get_loan
    @loan = Loan.includes(:payments).find(params[:loan_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :payment_date)
  end
end
