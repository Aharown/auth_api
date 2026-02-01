class UsersController < ApplicationController
  before_action :authorize_request, only: [:me]

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: "User created successfully"},
    status: :created
    else
      render json: { errors: user.errors.full_messages },
    status: :unprocessable_entity
    end
  end

  def me
    render json: { id: current_user.id, email: current_user.email }, status: :ok
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
