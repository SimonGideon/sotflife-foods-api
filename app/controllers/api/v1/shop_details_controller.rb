class Api::V1::ShopDetailsController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  before_action :require_admin, only: [:update]

  # GET /api/v1/shop_details/:id
  def show
    shop = ShopDetail.find_by(id: params[:id])
    if shop
      render json: shop, status: :ok
    else
      render json: { error: 'Shop not found' }, status: :not_found
    end
  end

  # PATCH /api/v1/shop_details/:id
  def update
    shop = ShopDetail.find_by(id: params[:id])
    if shop&.update(shop_detail_params)
      render json: shop, status: :ok
    else
      render json: { errors: shop&.errors&.full_messages || ['Shop not found'] }, status: :unprocessable_entity
    end
  end

  private

  def shop_detail_params
    params.require(:shop_detail).permit(:name, :address, :latitude, :longitude, :delivery_radius_km, :contact_phone, :open_time, :close_time)
  end
end 