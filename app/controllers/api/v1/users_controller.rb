class Api::V1::UsersController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_user!, only: [:index, :search, :logout]
  before_action :require_admin, only: [:index, :search]

  # GET /api/v1/users
  def index
    users = User.all
    render json: users.as_json(only: [:id, :name, :email, :phone, :role])
  end

  # GET /api/v1/users/search?q=term
  def search
    q = params[:q].to_s.strip
    users = User.where('name ILIKE :q OR email ILIKE :q OR phone ILIKE :q', q: "%#{q}%")
    render json: users.as_json(only: [:id, :name, :email, :phone, :role])
  end


  # supwer admin deleting profiles
  def delete_profile
    user = User.find(params[:id])
    user.destroy
    render json: { message: 'Profile deleted successfully.' }, status: :ok
  end

  # POST /api/v1/register
  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'User registered successfully.' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # updates user profile
  def update_profile
    user = User.find(params[:id])
    user.update(user_params)
    render json: { message: 'Profile updated successfully.' }, status: :ok
  end

  # POST /api/v1/login
  def login
    user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      jwt_payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      token = jwt_payload[0]
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # DELETE /api/v1/logout
  def logout
    if request.headers['Authorization'].present?
      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { error: 'No token provided.' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation, :role)
  end

end
