class ApplicationController < ActionController::API
  rescue_from JWT::DecodeError do |exception|
    render json: { error: "Invalid or expired token: #{exception.message}" }, status: :unauthorized
  end

  def current_user
    @current_user ||= User.find_by(id: decoded_token[0]['user_id']) if decoded_token
  end

  def decoded_token
    @decoded_token ||= JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, { algorithm: 'HS256' }) if token
  end
end