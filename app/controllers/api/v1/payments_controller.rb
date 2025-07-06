class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:show, :update]
  before_action :require_admin_or_order_owner, only: [:create, :update]

  # POST /api/v1/payments
  def create
    payment = Payment.new(payment_params)
    if payment.save
      render json: payment, status: :created
    else
      render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/payments/:id
  def show
    if can_view_payment?(@payment)
      render json: @payment, status: :ok
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  # PATCH /api/v1/payments/:id
  def update
    if @payment.update(payment_params)
      render json: @payment, status: :ok
    else
      render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_payment
    @payment = Payment.find_by(id: params[:id])
    render json: { error: 'Payment not found' }, status: :not_found unless @payment
  end

  def payment_params
    params.require(:payment).permit(:order_id, :amount, :payment_method, :status)
  end

  def require_admin_or_order_owner
    order = Order.find_by(id: params[:payment][:order_id])
    unless current_user&.admin? || (order && order.user_id == current_user.id)
      render json: { error: 'Forbidden: Admins or Order Owner only.' }, status: :forbidden
    end
  end

  def can_view_payment?(payment)
    return true if current_user.admin?
    return true if payment.order.user_id == current_user.id
    return true if current_user.rider? && payment.order.rider_id == current_user.id
    false
  end
end 