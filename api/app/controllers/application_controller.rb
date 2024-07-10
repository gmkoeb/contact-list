class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_user
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ').last
        jwt_payload = JWT.decode(token, jwt_secret_key).first
        @current_user = User.find_by(id: jwt_payload['sub'])
      rescue JWT::DecodeError
        render_unauthorized
      end
    else
      render_unauthorized
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  private

  def jwt_secret_key
    Rails.application.credentials.devise_jwt_secret_key!
  end

  def render_unauthorized
    render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
  end
end
