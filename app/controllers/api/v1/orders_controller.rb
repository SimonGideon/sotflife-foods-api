class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :update_status, :assign_rider]
  before_action :require_admin_or_superadmin, only: [:assign_rider]
  before_action :require_admin_or_rider, only: [:update_status]

  # POST /api/v1/orders
  def create
    order = current_user.orders.build(order_params)
    if order.save
      # Optionally, create order_items here if nested params are provided
      render json: order, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/orders
  def index
    # Clients see their own orders, admins see all, riders see assigned
    if current_user.admin?
      orders = Order.all
    elsif current_user.rider?
      orders = Order.where(rider_id: current_user.id)
    else
      orders = current_user.orders
    end
    render json: orders, status: :ok
  end

  # GET /api/v1/orders/:id
  def show
    if can_view_order?(@order)
      render json: @order, status: :ok
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  # PATCH /api/v1/orders/:id/update_status
  def update_status
    if @order.update(status: params[:status])
      render json: @order, status: :ok
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/orders/:id/assign_rider
  def assign_rider
    if @order.update(rider_id: params[:rider_id])
      render json: @order, status: :ok
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find_by(id: params[:id])
    render json: { error: 'Order not found' }, status: :not_found unless @order
  end

  

  def order_params
    params.require(:order).permit(:total_price, :delivery_address, :delivery_lat, :delivery_lng, :rider_id, order_items_attributes: [:menu_item_id, :quantity, :price])
  end

  def require_admin_or_rider
    unless current_user&.admin? || current_user&.rider?
      render json: { error: 'Forbidden: Admins or Riders only.' }, status: :forbidden
    end
  end

  def can_view_order?(order)
    return true if current_user.admin?
    return true if current_user.rider? && order.rider_id == current_user.id
    return true if order.user_id == current_user.id
    false
  end
end
