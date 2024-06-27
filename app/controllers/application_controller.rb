class ApplicationController < ActionController::API
  before_action :authorized

  def authorized
    render json: { message: 'Por favor, entre com seu login' }, status: :unauthorized unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  def current_user
    return nil unless decoded_token

    @current_user ||= User.find_by(id: decoded_token[0]['user_id'])
  end

  def decoded_token
    return nil unless auth_header

    begin
      JWT.decode(auth_header.split(' ')[1], Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def auth_header
    request.headers['Authorization']
  end
end
