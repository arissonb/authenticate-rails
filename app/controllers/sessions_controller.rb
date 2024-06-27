class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      unless get_cache(user.id)
        token = encode_token(user_id: user.id)
        set_cache(token, user.id)
      end
      render json: { user: user.id, token: get_cache(user.id) }, status: :ok
    else
      render json: { error: 'Email ou senha invalidos' }, status: :unauthorized
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload.merge(exp: 1.days.from_now.to_i), Rails.application.secrets.secret_key_base, 'HS256')
  end

  def set_cache(token, user_id)
    $redis.set("token_user_#{user_id}", token)
    $redis.expire("token_user_#{user_id}", 1.days.from_now.to_i)
  end

  def get_cache(user_id)
    $redis.get("token_user_#{user_id}")
  end
end
