class FoodsController < ApplicationController
  def index
    @foods = Food.where(user_id: @current_user.id).select(:name, :rate, :id)

    render json: { user: { id: @current_user.id, name: @current_user.name }, foods: @foods }, status: :ok
  end
end
