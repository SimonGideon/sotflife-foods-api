class ApplicationController < ActionController::API
  rescue_from JWT::DecodeError do |exception|
    render json: { error: "Invalid or expired token: #{exception.message}" }, status: :unauthorized
  end

  rescue_from ActionController::RoutingError do |exception|
    render json: { error: "Not Found: #{exception.message}" }, status: :not_found
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: "Record not found: #{exception.message}" }, status: :not_found
  end

  # Authenticate before_action
  def authenticate_user!
    render json: { error: 'Unauthorized: Token missing or invalid' }, status: :unauthorized unless current_user
  end

  # Returns the currently signed-in user
  def current_user
    @current_user ||= User.find_by(id: decoded_token['sub']) if decoded_token
  end

  # Extract and decode JWT token
  def decoded_token
    @decoded_token ||= begin
      JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, algorithm: 'HS256')[0]
    rescue JWT::DecodeError => e
      raise e
    end
  end

  # Extract raw token string from header
  def token
    auth_header = request.headers['Authorization']
    auth_header&.split(' ')&.last
  end

  # Handle unknown routes
  def route_not_found
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}"
  end

  def require_admin
    unless current_user&.admin?
      render json: { error: 'Forbidden: Admins only.' }, status: :forbidden
    end
  end

  def require_superadmin
    unless current_user&.superadmin?
      render json: { error: 'Forbidden: Superadmins only.' }, status: :forbidden
    end
  end
end
